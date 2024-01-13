using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PozyxPlayer : MonoBehaviour {

	private Vector3 velocity = Vector3.zero;
	private Vector3 rotation = Vector3.zero;
	public Rigidbody rb; 
	// Use this for initialization
	void Start () {


	}


	//Gets a movement vector 
//	public void MovePozyxPlayer (Vector3 _velocity){
//
//		velocity = _velocity;
//
//	}

//	public void RotatePozyxPlayer (Vector3 _rotation){
//
//		rotation = _rotation;
//
//	}
//



	public void initPlayer(int index){

		rb = GetComponent<Rigidbody> ();

	}

	public void MovePozyxPlayer(Vector3 pos){
		

		rb.transform.position = Vector3.SmoothDamp(rb.transform.position, pos, ref velocity, 0.1f);
			

	}
	// Update is called once per frame
	void Update () {
		
	}
}
