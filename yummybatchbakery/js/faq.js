"use strict";

const toggle = evt => {
    
    const linkElement = evt.currentTarget;                
    const h2Element = linkElement.parentNode;              
    const divElement = h2Element.nextElementSibling;       

    if (h2Element.hasAttribute("class")) {
        h2Element.removeAttribute("class");
    } else {
        h2Element.className="minus";
    }

    
    if (divElement.hasAttribute("class")) {
        divElement.removeAttribute("class");
    } else {
        divElement.className="answer";
    }

    evt.preventDefault();  
};

document.addEventListener("DOMContentLoaded", () => {
    
    const linkElements = faq.querySelectorAll("#faq a");
    
    	    
    for (let linkElement of linkElements) {
        linkElement.addEventListener("click", toggle);
    }
    
    linkElements[0].focus();       
});