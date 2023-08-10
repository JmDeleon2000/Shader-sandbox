using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rotate : MonoBehaviour
{
    float angle = Mathf.PI;
    void Update()
    {
        transform.LookAt(Vector3.zero);
        if (Input.GetKey(KeyCode.A))
        {
            angle += 10 * Time.deltaTime;
            transform.position = new Vector3(Mathf.Sin(angle) * 10, 
                                                transform.position.y,
                                                Mathf.Cos(angle) * 10);
        }
        if (Input.GetKey(KeyCode.D))
        {
            angle -= 10 * Time.deltaTime;
            transform.position = new Vector3(Mathf.Sin(angle) * 10,
                                                transform.position.y,
                                                Mathf.Cos(angle) * 10);
        }
    }
}
