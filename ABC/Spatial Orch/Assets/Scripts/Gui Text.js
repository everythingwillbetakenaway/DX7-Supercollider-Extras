var Button1 : Texture2D;
var Button2 : Texture2D;
var Leveltoload : String;
var isquit = false;
var Sound : AudioClip;

function OnMouseEnter()
{
	GetComponent.<GUITexture>().texture = Button2;
	GetComponent.<AudioSource>().PlayOneShot(Sound);
}

function OnMouseExit()
{
	GetComponent.<GUITexture>().texture = Button1;
}

function OnMouseUp()
{
	if (isquit)
	{
		Application.Quit();
	}
	else
	{
		Application.LoadLevel(Leveltoload);
	}
}

