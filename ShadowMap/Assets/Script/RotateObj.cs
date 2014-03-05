using UnityEngine;
using System.Collections;

public class RotateObj : MonoBehaviour {
	
	// Update is called once per frame
	void Update () {
		transform.RotateAround(Vector3.zero,
		                       Vector3.up,
		                       40 * Time.deltaTime);
	}
}
