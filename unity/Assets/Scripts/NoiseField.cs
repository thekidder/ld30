using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class NoiseField : MonoBehaviour {
	public GameObject player;
	public SpriteRenderer fade;
	
	public int width;
	public int height;
	
	public float ambientNoise;
	public float noiseCenter;
	
	public float noiseFrequency;
	
	public float ambientVisibility;
	
	private float lastNoiseGen = 0f;
	private float currentAmbient;
	private List<Beacon> beacons = new List<Beacon>();
	private List<VisibleObject> visibleThings = new List<VisibleObject>();
	private List<float> noise;
	private bool lose;
	private bool win;

	// Use this for initialization
	void Start () {
		currentAmbient = 0f;
		lose = false;
		win = false;
		GameObject pixel = (GameObject)Resources.Load("Prefabs/Pixel");
		
		for(int i = 0; i < width; ++i) {
			for(int j = 0; j < height; ++j) {
				GameObject go = (GameObject)GameObject.Instantiate(pixel);
				go.name = string.Format("noise_{0}_{1}", i, j);
				go.transform.parent = this.transform;
				go.transform.localPosition = new Vector3(PlayerController.SIZE * i, PlayerController.SIZE * j, 0);
            }
		}
		
		noise = new List<float>(width * height);
		for(int i = 0; i < width * height; ++i) {
			noise.Add(0f);
		}
	}
	
	// Update is called once per frame
	void Update () {
		if(lose) { return; }
		for(int i = 0; i < width; ++i) {
			for(int j = 0; j < height; ++j) {
				GameObject point = gameObject.transform.GetChild(j + i * height).gameObject;
				float alphaTerm = 1f;
				foreach(VisibleObject obj in visibleThings) {
					Vector2 dist = (Vector2)transform.position
						+ new Vector2(i * PlayerController.SIZE, j * PlayerController.SIZE)
						- (Vector2)obj.transform.position;
					float visionConstant = PlayerController.SIZE * PlayerController.SIZE * obj.visibility * obj.visibility;	
					alphaTerm = Mathf.Min(Mathf.Clamp(dist.sqrMagnitude, visionConstant - obj.magnitude * visionConstant, visionConstant) / visionConstant - ambientVisibility, alphaTerm);
				}
				
				Color c = point.GetComponent<SpriteRenderer>().color;
				c.a = Mathf.Max (alphaTerm, 5f * noise[j + i * height]);
				point.GetComponent<SpriteRenderer>().color = c;
			}
		}
	
		if(Time.time - lastNoiseGen < noiseFrequency) {
			return;
		}
		
		GenerateNoise();
	}
	
	void FixedUpdate() {
		if(lose || win) { return; }
		for(int i = 0; i < width; ++i) {
			for(int j = 0; j < height; ++j) {
				Vector2 pos = (Vector2)transform.position + new Vector2(i * PlayerController.SIZE, j * PlayerController.SIZE);
				
				float totalNoise = ambientNoise;
				foreach(Beacon b in beacons) {
					totalNoise += b.collectNoise(pos);
				}
				
				noise[j + i * height] = totalNoise;
			}
		}
		
		win = true;
		foreach(Beacon b in beacons) {
			if(!b.activated) {
				win = false;
				break;
			}
		}
		
		if(win) { 
			player.SetActive(false);
			StartCoroutine(WinCoroutine());
		}
	}
	
	public float NoiseAt(Vector2 pos) {
		int x = (int)(pos.x / PlayerController.SIZE + 0.5f);
		int y = (int)(pos.y / PlayerController.SIZE + 0.5f);
		return noise[y + x * height];
	}
	
	public void AddBeacon(Beacon beacon) {
		beacons.Add(beacon);
	}
	
	public void AddVisibleObject(VisibleObject obj) {
		visibleThings.Add(obj);
	}
	
	public void Lose() {
		lose = true;
		StartCoroutine(LoseCoroutine());
	}
	
	public void SetCurrentAmbientNoise(float n) {
		currentAmbient = n;
	}
	
	private IEnumerator LoseCoroutine() {
		for(int t = 0; t < 16; ++t) {
			for(int i = 0; i < width; ++i) {
				for(int j = 0; j < height; ++j) {
					GameObject point = gameObject.transform.GetChild(j + i * height).gameObject;
					noise[j + i * height] = Mathf.Clamp(noise[j + i * height] + 0.06f, 0f, 1f);
					
					Color c = point.GetComponent<SpriteRenderer>().color;
					c.a += 0.02f;
					point.GetComponent<SpriteRenderer>().color = c;
					
				}
			}
			GenerateNoise();
			yield return new WaitForSeconds(0.033f);
		}
		
		for(int t = 0; t < 5; ++t) {
			GenerateNoise();
			yield return new WaitForSeconds(0.033f);
        }
        
		Application.LoadLevel(Application.loadedLevel);
	}
	
	private IEnumerator WinCoroutine() {
		for(int t = 0; t < 33; ++t) {
			Color c = fade.color;
			c.a += 1f / 32f;
			fade.color = c;
			yield return new WaitForSeconds(0.033f);
		}
		int level = int.Parse(Application.loadedLevelName.Substring(5));
		++level;
		Application.LoadLevel("level" + level);
	}
	
	private void GenerateNoise() {
		lastNoiseGen = Time.time;
		for(int i = 0; i < width; ++i) {
			for(int j = 0; j < height; ++j) {
				GameObject point = gameObject.transform.GetChild(j + i * height).gameObject;
				float noiseRange = noise[j + i * height] + currentAmbient;
				float currentNoise = Random.Range(-noiseRange / 2f, noiseRange / 2f) + noiseCenter;
				point.GetComponent<SpriteRenderer>().color = new Color(
					currentNoise, currentNoise, currentNoise + 0.05f, point.GetComponent<SpriteRenderer>().color.a);
			}
		}
	}
}
