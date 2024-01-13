using UnityEngine;
using UnityEngine.Networking;

public class PlayerSetup : NetworkBehaviour {

	[SerializeField]
	Behaviour [] componentsToDisable; 

	Camera SceneCamera;


	void Start(){
		
		if (!isLocalPlayer) {
			for (int i = 0; i < componentsToDisable.Length; i++) {

				componentsToDisable [i].enabled = false;
			}
		} else {

			SceneCamera = Camera.main;
			if (SceneCamera != null) {

				SceneCamera.gameObject.SetActive (false);
			}

		}

	}

	void onDisable(){

		if (SceneCamera != null) {

			SceneCamera.gameObject.SetActive (true); 
		}

	}


}
