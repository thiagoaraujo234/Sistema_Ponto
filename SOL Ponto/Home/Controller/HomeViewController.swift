import UIKit
import CoreData

class HomeViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var horarioView: UIView!
    @IBOutlet weak var horarioLabel: UILabel!
    @IBOutlet weak var registrarButton: UIButton!

    // MARK: - Attributes
    
    private var timer: Timer?
    private lazy var camera = Camera()
    private lazy var controladorDeImagem = UIImagePickerController()
    
    var contexto: NSManagedObjectContext {
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return contexto
    }
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuraView()
        atualizaHorario()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configuraTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    // MARK: - Class methods
    
    func configuraView() {
        configuraBotaoRegistrar()
        configuraHorarioView()
        verificaHorarioEAlteraBotaoPonto()
    }
    
    func configuraBotaoRegistrar() {
        registrarButton.layer.cornerRadius = 5
    }
    
    func configuraHorarioView() {
        horarioView.backgroundColor = .white
        horarioView.layer.borderWidth = 3
        horarioView.layer.borderColor = UIColor.systemGray.cgColor
        horarioView.layer.cornerRadius = horarioView.layer.frame.height / 2
        verificaHorarioEAlteraBackground()
    }
    
    func configuraTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(atualizaHorario), userInfo: nil, repeats: true)
    }
    
    @objc func atualizaHorario() {
        let horarioAtual = FormatadorDeData().getHorario(Date())
        horarioLabel.text = horarioAtual
        verificaHorarioEAlteraBackground()
        verificaHorarioEAlteraBotaoPonto()
    }
    
    func tentaAbrirCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            camera.delegate = self
            camera.abrirCamera(self, controladorDeImagem)
        }
    }
    
    func verificaHorarioEAlteraBackground() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: Date())
        
        if let hour = components.hour, let minute = components.minute {
            if hour < 8 {
                // Se for antes de 8h, altere o background para verde
                view.backgroundColor = UIColor.systemGreen
            } else if hour == 8 && minute <= 15 {
                // Se for entre 8h e 8:15, altere o background para laranja
                view.backgroundColor = UIColor.systemOrange
            } else {
                // Se for depois de 8:15, altere o background para vermelho
                view.backgroundColor = UIColor.systemRed
            }
        }
    }
    
    func verificaHorarioEAlteraBotaoPonto() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: Date())
        
        if let hour = components.hour, hour >= 10 {
            // Se for após 10h, desative o botão de ponto e exiba a mensagem para justificar com RH
            registrarButton.isEnabled = false
            exibirMensagemJustificarRH()
        } else {
            // Caso contrário, mantenha o botão ativado
            registrarButton.isEnabled = true
        }
    }
    
    func exibirMensagemJustificarRH() {
        // Adicione aqui a lógica para exibir a mensagem para justificar com RH
        let alertController = UIAlertController(
            title: "Justificar Ponto",
            message: "Você passou das 10h. Por favor, justifique o atraso com o RH",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func registrarButton(_ sender: UIButton) {
        tentaAbrirCamera()
    }
}

extension HomeViewController: CameraDelegate {
    func didSelecFoto(_ image: UIImage) {
        let recibo = Recibo(status: false, data: Date(), foto: image)
        recibo.salvar(contexto)
    }
}
