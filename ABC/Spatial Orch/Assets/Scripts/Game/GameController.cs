using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameController : MonoBehaviour {

	public Map map;
	public Player user;
	public int pozyxIndex = 0;
	private int count = 0;
	public PozyxPlayer pplayer;
	//public SerialController serialC;
	public List <PozyxPlayer> playerList = new List<PozyxPlayer>(4);
	// Use this for initialization
	public GameObject mapSize;
	private List <string> posList = new List<string> (3);
	private bool posflag = false;
	void Start () {
		
	

	}



	public void initSystem(){

		Debug.Log ("HERE NOW");
		List<float> objectPos = new List<float>();
		float index = 0;
		foreach (GameObject objekt in map.sceneObjects){
			Vector3 rb = objekt.transform.position;
			float posx = rb.x;
			float posy = rb.y;
			float posz = rb.z;
			objectPos.Add (index);
			objectPos.Add (posx);
			objectPos.Add (posy);
			objectPos.Add (posz);
			OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/objectPos", objectPos);	
			Debug.Log (objectPos [0]);
			index++;
			objectPos.Clear();
		}


	}

//	public void getPlayerPos(List <float> playerPos){
//		
//		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/playerPos", playerPos);
//
//
//	}

	private float GetFloat(string stringValue, float defaultValue)
	{
		float result = defaultValue;
		float.TryParse(stringValue, out result);
		return result;
	}

	private void MovePlayer(int p_index, Vector3 pPos){


		Vector3 _movHorizontal = transform.right * pPos.x;
		Vector3 _movVertical = transform.forward * pPos.y;
		Vector3 _velocity = (_movHorizontal + _movVertical).normalized;
		playerList[p_index].MovePozyxPlayer(pPos);
	}


	void OnMessageArrived(string msg)
	{	
		
		if (count == 0) {
			posList.Add (msg);
			count++;
		}
		if ((count%4 == 0 )&& (posflag ==false)) {
			int ti = 0;
			//int ix = int.Parse (posList [0]);
			float px = GetFloat (posList [1], 0);
//			float py = GetFloat (posList [2], 0);
			float py = 1.0f;
			float pz = GetFloat (posList [3], 0);
			Vector3 posVector = new Vector3(px,py,pz);
			playerList[0].MovePozyxPlayer (posVector);
			OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/pozyxPlayerPos", posList);	

			Debug.Log("POSITION LIST : " + posList[0]+posList[1] + posList[2] + posList[3]);

			count = 0;
			posList.Clear ();
		
		}
		else{
			
			posList.Add (msg);
			count++;
		}


		Debug.Log (count);

	}


	void OnConnectionEvent(bool success)
	{
		if (success) {
			Debug.Log ("Connection established");
			createPozyxPlayer ();
		}
		else
			Debug.Log("Connection attempt failed or disconnection detected");
	}

	public void createPozyxPlayer()
	{

		PozyxPlayer temp = Instantiate(pplayer,new Vector3(24.0F ,0, 0), Quaternion.identity);
		playerList.Add (temp);
		pozyxIndex++;


	}
	void Update () {


	}
}
