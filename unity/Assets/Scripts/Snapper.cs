using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Snapper : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		transform.localPosition = new Vector3(
			Mathf.Round(transform.localPosition.x / PlayerController.SIZE) * PlayerController.SIZE,
			Mathf.Round(transform.localPosition.y / PlayerController.SIZE) * PlayerController.SIZE,
			transform.localPosition.z);
	}
}
