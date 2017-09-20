Platform9 Managed Kubernetes Demo
==============

Provisions servers, installs <a href="http://fission.io">Fission</a>, configures and deploys application (database, and UI) to Managed Kubernetes, deploys Fission task (a RESTful interface for the UI application to the database layer).

The application that is comprised of the above services is intended to demonstrate using Fission.io to read from a database, transform the data into a consumable format by the UI application, which does no processing on the data aside from rendering a graph with a client-side library from the RESTful interface provided by the Fission router. 

In a live iteration of such an application, this may be streaming data into MongoDB, being read by Fission, and passed to the client UI via a GET request to the Fission router to graph for the last X range of values. 

Application
-----------

The application can be viewed <a href="http://p9-demo-app.sfo2.gourmet.yoga/">here</a>.

Components
----------

<strong>fission-task</strong>

Contains the Fission task script (`task.py`) and the Python `env` for Fission, handling the dependencies for the job, and created using the Fission documentation on envs:

```
fission env create --name python --image quay.io/jmarhee/python-env
```

before creating the task:

```
fission function create --name p9-demo --env python --code task.py --url /readings --method GET
```

This task reads a timeseries of CO2 levels over the last 300 intervals in a MongoDB collection at a time (if this were live data, it would be a different set of 300 datapoints, for example), and pre-processes the `find()` query result into a format suitable for use with the graphing library in the UI.

<strong>kubernetes-yaml</strong>

`p9-demo-mongo.yaml` deploys a MongoDB instance with a data import seed job as the entrypoint (to populate the database collections), and configured a Kubernetes service to expose the MongoDB endpoint to the client in Fission task.

```
p9-demo-mongo.p9-demo.svc.cluster.local
```

`p9-demo-ui.yaml` deploys a small Ruby application that is a static application except for a single call to the Fission endpoint to generate the graph body.

 `debug.yaml` generates a container that can be used to troubleshoot a given namespace.

 <strong>mongodb</strong>

 This contains the dataset, a script to bootstrap the MongoDB container with the data, and applies an optional user-policy (the YAML above only creates it with in-cluster access, so this isn't totally necessary).

 <strong>sample-ui</strong>

This is small Ruby application that is entirely static, and only makes a single GET request to populate the dataPoints object in the graphing library:

```erb
  window.onload = function () {
    var chart = new CanvasJS.Chart("chartContainer",
    {

      title:{
      text: "CO2 Emissions Interval Readings"
      },
       data: [
      {
        type: "line",

        dataPoints: <%= HTTParty.get("http://router.fission.svc.cluster.local/readings").to_s %>
      }
      ]
    });

    chart.render();
  }
  ```

  which renders to the client as:

  ```
  window.onload = function () {
    var chart = new CanvasJS.Chart("chartContainer",
    {

      title:{
      text: "CO2 Emissions Interval Readings"
      },
       data: [
      {
        type: "line",

        dataPoints: [{"y": 377.04, "x": 1}, {"y": 375.52, "x": 2}, {"y": 380.69, "x": 3}, {"y": 379.21, "x": 4}, {"y": 377.12, "x": 5}, {"y": 378.38, "x": 6}, {"y": 379.44, "x": 7}, {"y": 376.07, "x": 8}, ...]
        ...
  ````

  *all* processing on the data is handled by the Fission task, and is delivered to the ERB template in its completed form. 

<strong>terraform</strong>

This contains all of the provider-level provisioning scripts used to create the environment to which I deployed Managed Kubernetes. 