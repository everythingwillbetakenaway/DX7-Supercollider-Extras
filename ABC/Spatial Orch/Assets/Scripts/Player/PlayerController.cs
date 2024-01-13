	using UnityEngine;
	[RequireComponent(typeof(PlayerMotor))]
	public class PlayerController : MonoBehaviour {

	[SerializeField]
	private float lookSensitivity = 3f;
	[SerializeField]
	private float speed = 5f;
	private PlayerMotor motor;

	void Start(){

		motor = GetComponent <PlayerMotor>();
		//OSC here

	}


	public Vector3 getPosition(){

		return motor.rb.position;

	}


	void Update(){
		
		float _xMov = Input.GetAxisRaw ("Horizontal"); //-1 and 1
		float _zMov = Input.GetAxisRaw ("Vertical");

		Vector3 _movHorizontal = transform.right * _xMov;
		Vector3 _movVertical = transform.forward * _zMov;


		Vector3 _velocity = (_movHorizontal + _movVertical).normalized * speed;

		//Apply mouvement
		motor.Move (_velocity);

		//Calculate rotation as a 3D Vector (turning around)
		//Pozyx Routing here
		float _yRot = Input.GetAxisRaw("Mouse X");
		Vector3 _rotation = new Vector3 (0f, _yRot, 0f) * lookSensitivity;


		//Apply Rotation
		motor.Rotate (_rotation);

		//Calculate camera
		float _xRot = Input.GetAxisRaw ("Mouse Y");
		Vector3 _cameraRotation = new Vector3 (_xRot, 0f, 0f) * lookSensitivity;

		//Apply camera rotation
		motor.RotateCamera(_cameraRotation);

	}



	}
