//
//  ViewController.swift
//  Ex00
//
//  Created by Antoine JOUANNAIS on 4/3/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // attributs
    var nombre: Int = 0
    var premier_nombre_saisi: Int = 0
    var operation: Int = 0
    var resultat: Int = 0
    @IBOutlet weak var ecran: UILabel!

    // methodes
    func display(content : Int) {
        ecran.text = String(content)
    }
    
    func addDigit(digit: Int) {
        //if self.nombre >= 999999999 || self.nombre <= -99999999 {
        //    print("Taille maxi atteinte ! Dernier chiffre ignoré")
        //}
        //else {
            self.nombre = self.nombre &* 10
            if self.nombre >= 0 {
                self.nombre = self.nombre &+ digit
            }
            else {
                self.nombre = self.nombre &- digit
            }
            display(content: self.nombre)
        //}
    }
    func trace(n1: Int, op: String, n2: Int, res: Int) {
        let str = String(n1) + op + String(n2) + "=" + String(res)
        print(str)
    }
    
    @IBAction func zero(_ sender: Any) {
        addDigit(digit: 0)
    }

    @IBAction func one(_ sender: Any) {
        addDigit(digit: 1)
    }
    @IBAction func two(_ sender: Any) {
        addDigit(digit: 2)
    }

    @IBAction func three(_ sender: Any) {
        addDigit(digit: 3)
    }
    
    @IBAction func four(_ sender: Any) {
        addDigit(digit: 4)
    }
    @IBAction func five(_ sender: Any) {
        addDigit(digit: 5)
    }
    @IBAction func six(_ sender: Any) {
        addDigit(digit: 6)
    }
    @IBAction func seven(_ sender: Any) {
        addDigit(digit: 7)
    }
    @IBAction func eight(_ sender: Any) {
        addDigit(digit: 8)
    }
    @IBAction func nine(_ sender: Any) {
        addDigit(digit: 9)
    }
    
    @IBAction func comma(_ sender: Any) {
        print("Desolé, la vigule n'est pas implémentée");
    }
    
    @IBAction func ac(_ sender: Any) {
        print("AC : effacement complet")
        self.nombre = 0
        self.premier_nombre_saisi = 0
        self.operation = 0
        ecran.text = " "
    }
    
    @IBAction func c(_ sender: Any) {
        print("C : effacement du dernier nombre")
        self.nombre = 0
        ecran.text = " "

    }
    
    @IBAction func neg(_ sender: Any) {
        print("NEG : inversion signe")
        /*
        if self.nombre >= 999999999 {
            print("Taille max atteinte ! Changement de signe ignoré")
        }
        else { */
            self.nombre = self.nombre &* (-1)
            ecran.text = String(self.nombre)
        // }
    }
    
    @IBAction func divide(_ sender: Any) {
        print("/ : division")
        self.operation = 4
        self.premier_nombre_saisi = self.nombre
        self.nombre = 0
    }
    @IBAction func multiply(_ sender: Any) {
        print("x : multiplication")
        self.operation = 3
        self.premier_nombre_saisi = self.nombre
        self.nombre = 0
    }
    @IBAction func minus(_ sender: Any) {
        print("- : soustraction")
        self.operation = 2
        self.premier_nombre_saisi = self.nombre
        self.nombre = 0
    }
    @IBAction func plus(_ sender: Any) {
        print("+ : addition")
        self.operation = 1
        self.premier_nombre_saisi = self.nombre
        self.nombre = 0
    }
    
    @IBAction func equal(_ sender: Any) {
        print("= : resultat")

        switch operation {
        case 1: // addition
            self.resultat = self.nombre + self.premier_nombre_saisi
            display(content: self.resultat)
            trace(n1: self.premier_nombre_saisi, op: "+", n2: self.nombre, res:self.resultat)
            
        case 2: // soustraction
            self.resultat = self.premier_nombre_saisi - self.nombre
            display(content: self.resultat)
            trace(n1: self.premier_nombre_saisi, op: "-", n2: self.nombre, res:self.resultat)

        case 3: // multiplication
            self.resultat = self.nombre &* self.premier_nombre_saisi
            display(content: self.resultat)
            trace(n1: self.premier_nombre_saisi, op: "x", n2: self.nombre, res:self.resultat)

        case 4: // division
            if self.nombre != 0 {
                self.resultat = self.premier_nombre_saisi / self.nombre
                display(content: self.resultat)
                trace(n1: self.premier_nombre_saisi, op: "/", n2: self.nombre, res:self.resultat)
            }
            else {
                ecran.text = "Erreur ! Division par zéro"
                self.resultat = 0
            }
            
        default:
            self.resultat = 0
            ecran.text = "Erreur ! Operation inconnue..."
            
        }
        self.premier_nombre_saisi = 0
        self.nombre = 0
   }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

