using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour {

	private PlayerController pc; 
	public Vector3 position; 
	Camera SceneCamera;
	void Start () {

		pc = GetComponent <PlayerController>();

	}
	
	// Update is called once per frame
	void Update () {

		position = pc.getPosition ();
		
	}
}
