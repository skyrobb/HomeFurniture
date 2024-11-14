
import UIKit

class FurnitureDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[.originalImage]
        if let originalImage = originalImage as? UIImage {
            furniture?.imageData = originalImage.jpegData(compressionQuality: 0.9)
            dismiss(animated: true)
            updateView()
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    var furniture: Furniture?
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var choosePhotoButton: UIButton!
    @IBOutlet var furnitureTitleLabel: UILabel!
    @IBOutlet var furnitureDescriptionLabel: UILabel!
    
    init?(coder: NSCoder, furniture: Furniture?) {
        self.furniture = furniture
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
            let image = UIImage(data: imageData) {
            photoImageView.image = image
        } else {
            photoImageView.image = nil
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Choose Image", style: .default, handler: { _ in imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)})
            alertController.addAction(photoLibraryAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)})
            alertController.addAction(cameraAction)
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func actionButtonTapped(_ sender: Any) {
        if photoImageView.image != nil && furnitureTitleLabel.text != nil && furnitureDescriptionLabel.text != nil {
            let activityViewController = UIActivityViewController(activityItems: [photoImageView.image!, furnitureTitleLabel.text!, furnitureDescriptionLabel.text!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}
