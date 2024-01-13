using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class PlayerMotor : MonoBehaviour {

	[SerializeField]
	private Camera cam;

	public int index;
	private Vector3 velocity = Vector3.zero;
	private Vector3 rotation = Vector3.zero;
	private Vector3 cameraRotation = Vector3.zero;
	public Rigidbody rb; 




	void Start(){

		rb = GetComponent<Rigidbody> ();


	}


	//Gets a movement vector 
	public void Move (Vector3 _velocity){

		velocity = _velocity;

	}

	public void Rotate (Vector3 _rotation){

		rotation = _rotation;

	}

	public void RotateCamera (Vector3 _cameraRotation){

		cameraRotation = _cameraRotation;

	}

	//Run Physics iteration
	void FixedUpdate (){

		PerformMovement ();
		PerformRotation ();
	}


	//Perform movement based on velocity variable

	void PerformMovement(){

		if (velocity != Vector3.zero) {
			//collide and phyiscs check
			Vector3 position = rb.position + velocity * Time.fixedDeltaTime; 
			rb.MovePosition(position);
//			int index = index;
			float x = position.x;
			float y = position.y;
			float z = position.z;
			List <float> playerPos = new List<float>();
			playerPos.Add(x);
			playerPos.Add(y);
			playerPos.Add(z);
			Debug.Log (x);
			OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/playerPos", playerPos);
			print (playerPos);
		}
	}


	void PerformRotation(){


		rb.MoveRotation (rb.rotation * Quaternion.Euler(rotation));

		if (cam != null) {
			cam.transform.Rotate (cameraRotation);
		}

	}


}
