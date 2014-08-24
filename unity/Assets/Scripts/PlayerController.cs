using UnityEngine;
using System.Collections;

public class PlayerController : MonoBehaviour {
	public const float SIZE = 32f;
	
	public NoiseField noise;
	public float movementForce;
	
	public float noiseLimit = 0.2f;
	
	public float noiseGrowth = 5f;
	public float noiseDecay = 2f;
	
	private float currentNoise = 0f;
	private bool lose;
	
	// Use this for initialization
	void Start () {
		lose = false;
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		if(lose) { return; }
	
		rigidbody2D.AddForce(new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical")) * Time.fixedDeltaTime * movementForce);
		
		float n = noise.NoiseAt(transform.position);
		
		if(n > noiseLimit) {
			if(currentNoise == 0f) {
				GetComponent<AudioSource>().Play();
			}
			currentNoise += Time.deltaTime * noiseGrowth * n;
		} else {
			currentNoise -= Time.deltaTime * noiseDecay;
			if(currentNoise == 0f) {
				GetComponent<AudioSource>().Stop();
			}
		}
		
		currentNoise = Mathf.Clamp(currentNoise, 0f, 1f);
		GetComponent<AudioSource>().volume = currentNoise * currentNoise;
		noise.SetCurrentAmbientNoise(currentNoise * currentNoise * 0.25f);
		
		lose = currentNoise == 1f;
		if(lose) {
			rigidbody2D.isKinematic = true;
			noise.Lose();
		}
		
	}
}
