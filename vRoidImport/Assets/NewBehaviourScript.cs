using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Animations;

public class ModelMover : MonoBehaviour
{
    Animator animator;
    AnimController animCon;
    [SerializeField] float moveSpeed = 4;
    [SerializeField] float rotSpeed = 120;
    // Start is called before the first frame update
    void Start()
    {
        animator = GetComponent<Animator>();
        animCon = new AnimController(animator);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey("up") || Input.GetKey(KeyCode.W))
        {
            animCon.IsRun = true;
            transform.position += transform.forward * moveSpeed * Time.deltaTime;
        }
        if (Input.GetKey("down") || Input.GetKey(KeyCode.S))
        {
            animCon.IsRun = true;
            transform.position -= transform.forward * moveSpeed * Time.deltaTime;
            
        }
        if (Input.GetKey("right") || Input.GetKey(KeyCode.D))
        {
            
            //transform.position += transform.right * moveSpeed * Time.deltaTime;
            Vector3 rot = transform.rotation.eulerAngles;
            Quaternion qrot = Quaternion.Euler(new Vector3(rot.x, rot.y + 90, rot.z));
            transform.rotation = Quaternion.RotateTowards(transform.rotation, qrot, rotSpeed * Time.deltaTime);
        }
        if (Input.GetKey("left") || Input.GetKey(KeyCode.A))
        {
            
            //transform.position -= transform.right * moveSpeed * Time.deltaTime;
            Vector3 rot = transform.rotation.eulerAngles;
            Quaternion qrot = Quaternion.Euler(new Vector3(rot.x, rot.y -90, rot.z));
            transform.rotation = Quaternion.RotateTowards(transform.rotation, qrot, rotSpeed * Time.deltaTime);
        }
        if (Input.GetKey("up") || Input.GetKey(KeyCode.W)|| Input.GetKey("down") || Input.GetKey(KeyCode.S))
        {
            
        }
        else
        {
            animCon.AllSetFalse();
        }
    }
}
public class AnimController
{
    Animator animator;
    public AnimController(Animator animator)
    {
        this.animator = animator;
    }
    public void AllSetFalse()
    {
        IsWalk = false;
        IsRun = false;
    }
    public bool IsWalk
    {
        get
        {
            return animator.GetBool("IsWalk");
        }
        set
        {
            animator.SetBool("IsWalk", value);
        }
    }
    public bool IsRun
    {
        get
        {
            return animator.GetBool("IsRun");
        }
        set
        {
            animator.SetBool("IsRun", value);
        }
    }
    
}
