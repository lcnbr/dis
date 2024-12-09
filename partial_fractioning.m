(* ::Package:: *)

(* ::Input:: *)
(*d1=k . k*)
(*d2=(k . k+2k . p+p . p)*)
(*d3=(k . k+2k . q+q . q)*)
(*d4=(k . k+2k . p+2k . q+p . p+2p . q+q . q)*)
(*d5=(k . k+k . p+2k . q+p . p/4+q . q+p . q)*)


(* ::Input:: *)
(*sol=Solve[{Coefficient[alpha1 k . k+alpha2(k . k+2k . p+p . p)+alpha3(k . k+2k . q+q . q)+alpha4(k . k+2k . p+2k . q+p . p+2p . q+q . q)+alpha5(k . k+k . p+2k . q+p . p/4+q . q+p . q) ,k . k]==0,*)
(*Coefficient[alpha1 k . k+alpha2(k . k+2k . p+p . p)+alpha3(k . k+2k . q+q . q)+alpha4(k . k+2k . p+2k . q+p . p+2p . q+q . q)+alpha5(k . k+k . p+2k . q+p . p/4+q . q+p . q)  ,k . p]==0,*)
(*Coefficient[alpha1 k . k+alpha2(k . k+2k . p+p . p)+alpha3(k . k+2k . q+q . q)+alpha4(k . k+2k . p+2k . q+p . p+2p . q+q . q)+alpha5(k . k+k . p+2k . q+p . p/4+q . q+p . q)  ,k . q]==0},{alpha1,alpha2,alpha3}][[1]]*)


(* ::Input:: *)
(*coeff1=(alpha1 k . k+alpha2(k . k+2k . p+p . p)+alpha3(k . k+2k . q+q . q)+alpha4(k . k+2k . p+2k . q+p . p+2p . q+q . q)+alpha5(k . k+k . p+2k . q+p . p/4+q . q+p . q))/.sol/.{alpha4->0}//Expand*)
(*coeff2=(alpha1 k . k+alpha2(k . k+2k . p+p . p)+alpha3(k . k+2k . q+q . q)+alpha4(k . k+2k . p+2k . q+p . p+2p . q+q . q)+alpha5(k . k+k . p+2k . q+p . p/4+q . q+p . q))/.sol/.{alpha5->0}//Expand*)


(* ::Input:: *)
(*(alpha1 D1+alpha2 D2+alpha3 D3+alpha4 D4+alpha5 D5-coeff1)/.sol/.{alpha4->0,alpha5->1}//Expand*)
(*(alpha1 D1+alpha2 D2+alpha3 D3+alpha4 D4+alpha5 D5-coeff2)/.sol/.{alpha5->0,alpha4->1}//Expand*)
(*(alpha1 d1+alpha2 d2+alpha3 d3+alpha4 d4+alpha5 d5-coeff1)/.sol/.{alpha4->0,alpha5->1}//Expand*)
(*(alpha1 d1+alpha2 d2+alpha3 d3+alpha4 d4+alpha5 d5-coeff2)/.sol/.{alpha5->0,alpha4->1}//Expand*)


(* ::Input:: *)
(*P1=1/coeff1(alpha1 D1+alpha2 D2+alpha3 D3+alpha4 D4+alpha5 D5)/.sol/.{alpha4->0,alpha5->1}*)
(*P2=1/coeff2(alpha1 D1+alpha2 D2+alpha3 D3+alpha4 D4+alpha5 D5)/.sol/.{alpha5->0,alpha4->1}*)


(* ::Input:: *)
(*1/(D1 D2 D3 D4 D5)P1//Expand*)
