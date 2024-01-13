using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class oscInit : MonoBehaviour {

	// Use this for initialization
	void Awake () {
		OSCHandler.Instance.Init ();
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
