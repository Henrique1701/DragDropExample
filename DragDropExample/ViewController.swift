//
//  ViewController.swift
//  DragDropExemple
//
//  Created by José Henrique Fernandes Silva on 20/07/21.
//

import UIKit

class ViewController: UIViewController, UIDropInteractionDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.imageView.isUserInteractionEnabled = true
        self.customEnableDropping(on: self.imageView, dropInteractionDelegate: self)
        self.activityIndicator.isHidden = true
    }
    
    /// Função responsável por habilitar  o drop de uma view específica
    func customEnableDropping(on view: UIView, dropInteractionDelegate: UIDropInteractionDelegate) {
        view.isUserInteractionEnabled = true
        let dropInteraction = UIDropInteraction(delegate: dropInteractionDelegate)
        view.addInteraction(dropInteraction)
    }
    
    // MARK: Específica quais tipos de dados serão aceitos
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        // Ensure the drop session has an object of the appropriate type
        // Aqui eu poderia colocar todos os tipos que vai aceitar o drop
        //session.canLoadObjects(ofClass: UIImage.self )
        session.canLoadObjects(ofClass: NSString.self)
        return true
    }
    
    // MARK: - Função chamada toda vez que começa uma interação
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        self.imageView.tintColor = .systemGreen
    }
    
    // MARK: - Responsável por dizer o que deve acontece com o dado
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        // Nesse estamos dizendo que ele deve ser copiado
        UIDropProposal(operation: .copy)
    }
    
    // MARK: - Responsável por carregar o dado
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        self.imageView.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        // A função loadObjects pode demorar para responder
        session.loadObjects(ofClass: UIImage.self) { imageItens in
            DispatchQueue.main.async {
                print("Entrou")
                let images = imageItens as! [UIImage]
                self.imageView.image = images.first
            }
        }
    }
    
    // MARK: - Função que é chamada toda vez que a interação acaba
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        print("sessionDidEnd")
        if self.imageView != nil {
            self.imageView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    // MARK: - Função que é chamada toda vez que o item sai de cima da view
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        print("sessionDidExit")
        self.imageView.tintColor = .systemBlue
    }

}

