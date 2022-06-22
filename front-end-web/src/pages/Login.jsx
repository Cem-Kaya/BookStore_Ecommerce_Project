import styled from "styled-components";
import React, { useState } from "react";
import Header from "../components/Header";
import Signin from '../components/Signin'
import Signup from '../components/Signup'
import Footer from "../components/Footer";
import { useNavigate } from "react-router-dom";
import { useEffect } from 'react';
import { logIn, signUp, checkLogInStatus } from "../helperFunctions/helperLogin";
import Alert from 'react-bootstrap/Alert'
import { synchronizeWithDb } from "../helperFunctions/helperCartItems";

const Container = styled.div`
  width: 100%;
  height: 100vh;
  background: linear-gradient(
      rgba(255, 255, 255, 0.5),
      rgba(255, 255, 255, 0.5)
    ),
    url("data:image/jpeg;base64,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")
      center;
  background-size: cover;
  justify-content: center;
  align-items:center

  
 
`;
const Button = styled.button`
  width: 10%;
  border: none;
  padding: 15px 20px;
  background-color: teal;
  color: white;
  cursor: pointer;
  margin-top: 10px;
  margin-left: 10px;
`;
const Form = styled.form`
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items:center;
  margin-right:24px;
`;

const Login = () => {

  let loginStatus = false
  const navigate = useNavigate()

  const LogIn = async (email, passHash) =>  {
    try{
      const serverAnswer = await logIn(email, passHash)
      console.log("Server answer: " , serverAnswer)
      setValues(serverAnswer)
    }
    catch (e){
      console.log(e)
    }
    if(checkLogInStatus()){
      await synchronizeWithDb()
      setSuccessMessageFunction(`Logged in as: ${email}`)
    }
    else{
      setErrorMessageFunction("Could Not Log In")
    }
  }
  
  const SignUp = async (username, email, passHash, homeAddress, taxID) =>  {
    try{
      const serverAnswer = await signUp(username, email, passHash, homeAddress, taxID)
      setValues(serverAnswer)
    }
    catch(e){
      console.log(e)
    }

    if(checkLogInStatus()){
      await synchronizeWithDb()
      setSuccessMessageFunction(`Signed up as: ${email}`)
    }
    else{
      setErrorMessageFunction("Could Not Sign Up")
    }
  }

  const setErrorMessageFunction = (message) => {
    setErrorMessage(message)
    setAlertBoxOpen(true)
  }

  const setSuccessMessageFunction = (message) => {
    setSuccessMessage(message)
    setSuccessBoxOpen(true)
  }

  const setValues = (serverAnswer) => {
    loginStatus = serverAnswer["status"]
    console.log(loginStatus)
  }

const types= ['LOGIN', 'SIGNUP']
const [type,setType]= useState()
const [alertBoxOpen, setAlertBoxOpen] = useState(false)
const [errorMessage, setErrorMessage] = useState(false)
const [successBoxOpen, setSuccessBoxOpen] = useState(false)
const [successMessage, setSuccessMessage] = useState(false)

function ToogleGroup(){

  const isempty = type==='';
  if (isempty) {
      setType(types[0])   
  }
  const istype = type==='LOGIN';
    return(
      <Container>
        <Alert key={"danger"} show={alertBoxOpen} variant={"danger"}>
          {errorMessage}
        </Alert>
        <Alert key={"success"} show={successBoxOpen} variant={"success"}>
          {successMessage + "   "}
          <a href="/">
            Go Back To The Home Page
          </a>
        </Alert>
      <Form>
        {types.map((type, index) =>(
          <Button  key={index} onClick={()=> {setType(type); setAlertBoxOpen(false)}}>
            {type}
          </Button>
        ))}
      </Form>
      {istype ? (<Signin onLogin={LogIn} onWrongInput={setErrorMessageFunction}></Signin>) : 
                (<Signup onSignUp={SignUp} onWrongInput={setErrorMessageFunction}></Signup>)      
      }
      </Container>
    );
  }
  return (
   <div>
      <Header></Header>
      <ToogleGroup/>
      <Footer></Footer>
   </div>
  );
};

export default Login;