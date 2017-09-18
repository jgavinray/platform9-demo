import pymongo
import json

client =  pymongo.MongoClient("p9-demo-mongo.p9-demo.svc.cluster.local", 27017)
db = client.couptake
readings = db.readingSeries

def recordRead(day):
	count = 0
	for reading in readings.find({"ReadingSeq": int("%s" % (day))},{"_id":0, "Day":0}):
		prepAxis = json.dumps(reading).replace("ReadingSeq","x")
		return json.loads(prepAxis.replace("CO2","y"))

def main():
	response = []
	for d in range(1,238):
		response.append(recordRead(d))
	return json.dumps(response)