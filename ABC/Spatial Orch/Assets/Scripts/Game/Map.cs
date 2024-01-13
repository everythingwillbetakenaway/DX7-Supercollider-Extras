using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Map : MonoBehaviour {
	
	public List<GameObject> sceneObjects = new List<GameObject>(5);
	public GameObject[] objekt;
	public GameController gc; 

	void Start () {
		float isCreated = 1.0f;
		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/sceneboot",isCreated);
		CreateMap ();
	}

	public void CreateMap(){
		for (int x = 0; x < objekt.Length; x++) {
			
			GameObject sceneObject = (GameObject)Instantiate(objekt[x], new Vector3( Random.Range(-20.0f, 20.0f) ,0,  Random.Range(-20.0f, 20.0f)), Quaternion.identity);
			sceneObject.transform.parent = transform;
			sceneObjects.Add (sceneObject);
		}
		gc.initSystem ();
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
