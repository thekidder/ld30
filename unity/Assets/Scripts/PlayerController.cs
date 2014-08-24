using UnityEngine;
using System.Collections;

public class PlayerController : MonoBehaviour {
	public const float SIZE = 32f;
	
	public NoiseField noise;

	private float lastMovementTime = 0f;
	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		if(Time.time - lastMovementTime > 0.02f) {
			transform.localPosition = new Vector3(
				Mathf.Clamp(transform.localPosition.x + Input.GetAxisRaw("Horizontal") * SIZE, 0f, SIZE * (noise.width - 1)),
				Mathf.Clamp(transform.localPosition.y + Input.GetAxisRaw("Vertical") * SIZE, 0f, SIZE * (noise.height - 1)),
				transform.localPosition.z + 0f);
			lastMovementTime = Time.time;
		}
	}
}
