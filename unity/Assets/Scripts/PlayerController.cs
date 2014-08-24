using UnityEngine;
using System.Collections;

public class PlayerController : MonoBehaviour {
	public const float SIZE = 32f;

	private float lastMovementTime = 0f;
	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		if(Time.time - lastMovementTime > 0.02f) {
			transform.localPosition = transform.localPosition + new Vector3(
				Input.GetAxisRaw("Horizontal") * SIZE,
				Input.GetAxisRaw("Vertical") * SIZE,
				0f);
			lastMovementTime = Time.time;
		}
	}
}
