"use strict";

const $ = selector => document.querySelector(selector); 

const displayErrorMsgs = msgs => {
    
    const ul = document.createElement("ul");
    ul.classList.add("messages");

    for (let msg of msgs) {
        const li = document.createElement("li");
        const text = document.createTextNode(msg);
        li.appendChild(text);
        ul.appendChild(li);
    }

    const node = $("ul");
    if (node == null) {
        
        const form = $("form");

        
        form.parentNode.insertBefore(ul, form);
    } else {
        
        node.parentNode.replaceChild(ul, node);
    }  
}

const processEntries = () => {
   
    const email = $("#email_address");
    const phone = $("#phone");
    const country = $("#country");
    const terms = $("#terms");
    const comments = $("#comments");

    
    const msgs = [];

    
    if (email.value == "") {
        msgs[msgs.length] = "Please enter an email address.";
    } 
    if (phone.value == "") {
        msgs[msgs.length] = "Please enter a mobile phone number."; 
    } 
    if (country.value == "") {
        msgs[msgs.length] = "Please select a country.";
    } 
    if (terms.checked == false) {
        msgs[msgs.length] = "You must agree to the terms of service."; 
    }
    if (comments.value == "") {
        msgs[msgs.length] = "Please enter a comment.";
    }

    
    if (msgs.length == 0) {  
        $("form").submit(); 
    } else {
        displayErrorMsgs(msgs);
    }
};

const resetForm = () => {
    $("form").reset();
    
    
    $("ul").remove();
    
    $("#email_address").focus();
};

document.addEventListener("DOMContentLoaded", () => {
    $("#register").addEventListener("click", processEntries);
    $("#reset_form").addEventListener("click", resetForm);  
    $("#email_address").focus();
    
    $("#join_list").addEventListener("click", () => {
        
        const email1 = $("#email_1");
        const email2 = $("#email_2");
        const firstName = $("#first_name");
    
        
        let isValid = true;

        
        if (email1.value == "") {
            email1.nextElementSibling.textContent = "This field is required.";
            isValid = false; 
        } else {
            email1.nextElementSibling.textContent = "";
        }
    
        if (email2.value == "") { 
            email2.nextElementSibling.textContent = "This field is required.";
            isValid = false; 
        } else {
            email2.nextElementSibling.textContent = "";
        }
    
        if (email1.value != email2.value) { 
            email2.nextElementSibling.textContent = "Email addresses must match.";
            isValid = false; 
        }
    
        if (firstName.value == "") {
            firstName.nextElementSibling.textContent = "First name is required.";
            isValid = false;
        } else {
            firstName.nextElementSibling.textContent = "";
        }
    
        if (isValid) {
            $("#email_form").submit();
        }
    });

    $("#clear_form").addEventListener("click", () => {
        $("#email_1").value = "";
        $("#email_2").value = "";
        $("#first_name").value = "";

        $("#email_1").focus();
    });
    
    $("#email_1").focus();
});