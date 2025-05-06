using UnityEngine;
using System.Collections;

public class PrefabSpawner : MonoBehaviour
{
    public GameObject prefab;  // Assign in Inspector
    public GameObject vroidVoicePrefab; // Assign the VRoidVoice prefab

    public int spawnCount = 5; // Number of objects
    public float spacing = 0.3f; // Distance between each object
    public float rotationDuration = 12.0f; // Time to rotate smoothly (seconds)

    void Start()
    {
        for (int i = 0; i < spawnCount; i++)
        {
            float xPos = i * 0.3f;  // Direct float multiplication
            Vector3 spawnPosition = new Vector3(xPos-0.75f, 0, 2);
            Debug.Log("Spawn Position X: " + xPos);  // Debugging
            GameObject obj = Instantiate(prefab, spawnPosition, Quaternion.identity);

            obj.AddComponent<Rotator>();  
            AttachVRoidVoice(obj);

            // Start smooth rotation with a delay for each object
            //StartCoroutine(RotateSmoothly(obj, i * 0.5f)); // Delay increases for each object
        }


    }
    void AttachVRoidVoice(GameObject model)
    {
        // Ensure vroidVoicePrefab is assigned in Inspector
        if (vroidVoicePrefab == null)
        {
            Debug.LogError("VRoidVoice Prefab is not assigned!");
            return;
        }

        // Instantiate VRoidVoice and set its parent to the model
        GameObject vroidVoiceInstance = Instantiate(vroidVoicePrefab);
        vroidVoiceInstance.transform.SetParent(model.transform); // Attach to model
        vroidVoiceInstance.transform.localPosition = Vector3.zero; // Position correctly

        Debug.Log($"VRoidVoice attached to {model.name}");
    }

    IEnumerator RotateSmoothly(GameObject obj, float delay)
    {
        yield return new WaitForSeconds(delay); // Wait before rotating

        float elapsedTime = 0f;
        Quaternion startRotation = obj.transform.rotation;
        Quaternion targetRotation = Quaternion.Euler(0, 180, 0); // Rotate 180 degrees

        while (elapsedTime < rotationDuration)
        {
            obj.transform.rotation = Quaternion.Lerp(startRotation, targetRotation, elapsedTime / rotationDuration);
            elapsedTime += Time.deltaTime;
            yield return null; // Wait for the next frame
        }

        obj.transform.rotation = targetRotation; // Ensure it reaches exactly 180 degrees
    }

    public class Rotator : MonoBehaviour
    {
        public float speed = 10f; // Rotation speed

        void Update()
        {
            transform.Rotate(0, speed * Time.deltaTime, 0); // Rotate around Y-axis forever
        }
    }    
}