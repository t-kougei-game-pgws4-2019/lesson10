﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GenerateBehaviourScript : MonoBehaviour
{
    public InstancedBehaviourScript prefab;
    public int INSTANCE_NUM = 1000;
    int last_instance_num = 1000;

    void generate()
    {
        for (int i = 0; i < INSTANCE_NUM; i++)
        {
            var inst = Instantiate(prefab);
            inst.transform.parent = gameObject.transform;

            float y = Random.Range(0.3f, 1.5f);
            inst.transform.localScale=new Vector3(0.1f, y, 0.1f);

            inst.transform.position = new Vector3(Random.Range(-5.0f, 5.0f), y, Random.Range(-5.0f, 5.0f));

            //inst.color.r = Random.Range(0.0f, 1.0f);
            inst.color.r = 0.0f;
            inst.color.g = Random.Range(0.4f, 1.0f);
            //inst.color.b = Random.Range(0.0f, 1.0f);
            inst.color.b = 0.0f;
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        generate();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnValidate()
    {
        if (last_instance_num != INSTANCE_NUM)
        {
            last_instance_num = INSTANCE_NUM;

            for (int i = 0; i < gameObject.transform.childCount; i++)
            {
                Destroy(gameObject.transform.GetChild(i).gameObject);
            }
            generate();
        }
    }
}
