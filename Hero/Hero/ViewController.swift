//
//  ViewController.swift
//  Hero
//


import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentStack: UIStackView!
    @IBOutlet private weak var heroImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var attributeStack: UIStackView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var featuredLabel: UILabel!
    @IBOutlet private var featuredButtons: [UIButton]!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var randomizeButton: UIButton!

    private let service = SuperheroService()
    private let imageLoader = ImageLoader()

    private var currentImageTask: URLSessionDataTask?
    private var currentImageURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchRandomHero(animated: false)
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        contentStack.axis = .vertical
        contentStack.spacing = 16

        heroImageView.backgroundColor = .secondarySystemBackground
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.layer.cornerRadius = 16
        heroImageView.layer.masksToBounds = true

        nameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.7
        nameLabel.numberOfLines = 2

        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        attributeStack.axis = .vertical
        attributeStack.spacing = 12

        statusLabel.text = "Tap the button to meet a hero!"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        statusLabel.textColor = .secondaryLabel
        statusLabel.numberOfLines = 0

        featuredLabel.text = "Featured Heroes"
        featuredLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        featuredLabel.textColor = .secondaryLabel

        activityIndicator.hidesWhenStopped = true

        configureButton()
        configureFeaturedButtons()
    }

    private func configureButton() {
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = "Randomize Superhero"
            config.cornerStyle = .large
            config.buttonSize = .large
            randomizeButton.configuration = config
        } else {
            randomizeButton.setTitle("Randomize Superhero", for: .normal)
            randomizeButton.backgroundColor = .systemBlue
            randomizeButton.tintColor = .white
            randomizeButton.layer.cornerRadius = 14
            randomizeButton.contentEdgeInsets = UIEdgeInsets(top: 18, left: 16, bottom: 18, right: 16)
        }
    }

    private func configureFeaturedButtons() {
        featuredButtons.forEach { button in
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.gray()
                config.cornerStyle = .capsule
                config.title = button.currentTitle
                config.buttonSize = .medium
                button.configuration = config
            } else {
                button.setTitleColor(.systemBlue, for: .normal)
                button.layer.cornerRadius = 18
                button.layer.borderColor = UIColor.systemBlue.cgColor
                button.layer.borderWidth = 1
                button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
            }
        }
    }

    @IBAction private func randomizeTapped(_ sender: UIButton) {
        fetchRandomHero(animated: true)
    }

    @IBAction private func featuredHeroTapped(_ sender: UIButton) {
        guard let heroName = sender.currentTitle else { return }
        fetchHero(named: heroName)
    }

    private func fetchRandomHero(animated: Bool) {
        toggleLoading(true)
        statusLabel.text = "Fetching a random superhero..."

        service.randomHero { [weak self] result in
            guard let self else { return }
            self.toggleLoading(false)
            switch result {
            case .success(let hero):
                self.render(hero: hero, animated: animated)
            case .failure(let error):
                self.statusLabel.text = "Something went wrong. Please try again."
                self.presentErrorAlert(message: error.localizedDescription)
            }
        }
    }

    private func fetchHero(named name: String) {
        toggleLoading(true)
        statusLabel.text = "Summoning \(name)..."

        service.hero(named: name) { [weak self] result in
            guard let self else { return }
            self.toggleLoading(false)
            switch result {
            case .success(let hero):
                self.render(hero: hero, animated: true)
            case .failure(let error):
                self.statusLabel.text = "Could not find \(name). Try again!"
                self.presentErrorAlert(message: error.localizedDescription)
            }
        }
    }

    private func render(hero: Superhero, animated: Bool) {
        nameLabel.text = hero.name
        let fullName = hero.biography.fullName.trimmedOrUnknown
        subtitleLabel.text = fullName == "Unknown" ? "Secret identity classified" : fullName
        statusLabel.text = nil
        subtitleLabel.isHidden = fullName == "Unknown"

        renderAttributes(items: attributeItems(for: hero))
        loadImage(for: hero, animated: animated)

        if animated {
            animateContent()
        }
    }

    private func renderAttributes(items: [(String, String)]) {
        attributeStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        items.forEach { title, value in
            let row = AttributeRowView(title: title)
            row.update(value: value)
            attributeStack.addArrangedSubview(row)
        }
    }

    private func loadImage(for hero: Superhero, animated: Bool) {
        currentImageTask?.cancel()
        heroImageView.image = nil
        guard let url = hero.images.largestImageURL else {
            heroImageView.image = UIImage(systemName: "person.crop.square")
            return
        }
        currentImageURL = url
        currentImageTask = imageLoader.loadImage(from: url) { [weak self] result in
            guard let self else { return }
            guard self.currentImageURL == url else { return }
            switch result {
            case .success(let image):
                UIView.transition(with: self.heroImageView, duration: animated ? 0.35 : 0, options: .transitionCrossDissolve, animations: {
                    self.heroImageView.image = image
                })
            case .failure:
                self.heroImageView.image = UIImage(systemName: "person.crop.square")
            }
        }
    }

    private func animateContent() {
        let views: [UIView] = [heroImageView, nameLabel, subtitleLabel, attributeStack]
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut) {
            views.forEach { $0.alpha = 1 }
        }
    }

    private func toggleLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }

        randomizeButton.isEnabled = !isLoading
        UIView.animate(withDuration: 0.2) {
            self.randomizeButton.alpha = isLoading ? 0.6 : 1.0
        }
    }

    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.fetchRandomHero(animated: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func attributeItems(for hero: Superhero) -> [(String, String)] {
        [
            ("Full Name", hero.biography.fullName.trimmedOrUnknown),
            ("Alter Egos", hero.biography.alterEgos.trimmedOrUnknown),
            ("Alignment", hero.biography.alignment.trimmedOrUnknown.capitalized),
            ("Place of Birth", hero.biography.placeOfBirth.trimmedOrUnknown),
            ("First Appearance", hero.biography.firstAppearance.trimmedOrUnknown),
            ("Gender", hero.appearance.gender.trimmedOrUnknown),
            ("Race", hero.appearance.race?.trimmedOrUnknown ?? "Unknown"),
            ("Height", hero.appearance.height.readableList),
            ("Weight", hero.appearance.weight.readableList),
            ("Occupation", hero.work.occupation.trimmedOrUnknown),
            ("Connections", hero.connections.groupAffiliation.trimmedOrUnknown),
            ("Intelligence", hero.powerstats.intelligence.readableStat),
            ("Strength", hero.powerstats.strength.readableStat),
            ("Speed", hero.powerstats.speed.readableStat),
            ("Durability", hero.powerstats.durability.readableStat),
            ("Power", hero.powerstats.power.readableStat),
            ("Combat", hero.powerstats.combat.readableStat)
        ]
    }
}

// MARK: - Networking

private final class SuperheroService {
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let endpoint = URL(string: "https://akabab.github.io/superhero-api/api/all.json")!

    private var cachedHeroes: [Superhero] = []
    private var isLoading = false
    private var queuedCompletions: [(Result<[Superhero], Error>) -> Void] = []

    init(session: URLSession = .shared) {
        self.session = session
    }

    func randomHero(completion: @escaping (Result<Superhero, Error>) -> Void) {
        loadHeroes { result in
            switch result {
            case .success(let heroes):
                guard let hero = heroes.randomElement() else {
                    completion(.failure(ServiceError.emptyDataset))
                    return
                }
                completion(.success(hero))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func hero(named name: String, completion: @escaping (Result<Superhero, Error>) -> Void) {
        loadHeroes { result in
            switch result {
            case .success(let heroes):
                if let hero = heroes.first(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) {
                    completion(.success(hero))
                } else {
                    completion(.failure(ServiceError.heroNotFound(name)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func loadHeroes(completion: @escaping (Result<[Superhero], Error>) -> Void) {
        if !cachedHeroes.isEmpty {
            completion(.success(cachedHeroes))
            return
        }

        queuedCompletions.append(completion)
        guard !isLoading else { return }

        isLoading = true
        let request = URLRequest(url: endpoint, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)

        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            defer { self.isLoading = false }

            let result: Result<[Superhero], Error>

            if let error {
                result = .failure(error)
            } else if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                result = .failure(ServiceError.invalidStatusCode(httpResponse.statusCode))
            } else if let data {
                do {
                    let heroes = try self.decoder.decode([Superhero].self, from: data)
                    self.cachedHeroes = heroes
                    result = .success(heroes)
                } catch {
                    result = .failure(error)
                }
            } else {
                result = .failure(ServiceError.emptyData)
            }

            DispatchQueue.main.async {
                self.queuedCompletions.forEach { $0(result) }
                self.queuedCompletions.removeAll()
            }
        }.resume()
    }

    enum ServiceError: LocalizedError {
        case invalidStatusCode(Int)
        case emptyData
        case emptyDataset
        case heroNotFound(String)

        var errorDescription: String? {
            switch self {
            case .invalidStatusCode(let code):
                return "Server responded with status code \(code)."
            case .emptyData:
                return "The server returned no data."
            case .emptyDataset:
                return "Could not find any heroes to display."
            case .heroNotFound(let name):
                return "\(name) is missing from the database."
            }
        }
    }
}

// MARK: - Image Loader

private final class ImageLoader {
    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    @discardableResult
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(.success(cachedImage))
            return nil
        }

        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }

            let result: Result<UIImage, Error>

            if let error {
                result = .failure(error)
            } else if let data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url as NSURL)
                result = .success(image)
            } else {
                result = .failure(ServiceError.invalidImageData)
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }

        task.resume()
        return task
    }

    enum ServiceError: LocalizedError {
        case invalidImageData

        var errorDescription: String? {
            "The hero image could not be decoded."
        }
    }
}

// MARK: - Models

private struct Superhero: Decodable {
    let id: Int
    let name: String
    let powerstats: Powerstats
    let appearance: Appearance
    let biography: Biography
    let work: Work
    let connections: Connections
    let images: Images

    struct Powerstats: Decodable {
        let intelligence: Int?
        let strength: Int?
        let speed: Int?
        let durability: Int?
        let power: Int?
        let combat: Int?
    }

    struct Appearance: Decodable {
        let gender: String
        let race: String?
        let height: [String]
        let weight: [String]
    }

    struct Biography: Decodable {
        let fullName: String
        let alterEgos: String
        let placeOfBirth: String
        let firstAppearance: String
        let alignment: String
    }

    struct Work: Decodable {
        let occupation: String
    }

    struct Connections: Decodable {
        let groupAffiliation: String
    }

    struct Images: Decodable {
        let xs: String
        let sm: String
        let md: String
        let lg: String

        var largestImageURL: URL? {
            [lg, md, sm, xs]
                .compactMap { URL(string: $0) }
                .first
        }
    }
}

// MARK: - Attribute Row

private final class AttributeRowView: UIStackView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    init(title: String) {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 2

        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = .secondaryLabel
        titleLabel.text = title.uppercased()

        valueLabel.font = UIFont.preferredFont(forTextStyle: .body)
        valueLabel.numberOfLines = 0

        addArrangedSubview(titleLabel)
        addArrangedSubview(valueLabel)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(value: String) {
        valueLabel.text = value
    }
}

// MARK: - Helpers

private extension String {
    var trimmedOrUnknown: String {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed == "-" {
            return "Unknown"
        }
        return trimmed
    }
}

private extension Array where Element == String {
    var readableList: String {
        let cleaned = self
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty && $0 != "-" }
        return cleaned.isEmpty ? "Unknown" : cleaned.joined(separator: " / ")
    }
}

private extension Optional where Wrapped == Int {
    var readableStat: String {
        guard let value = self else { return "N/A" }
        return "\(value)"
    }
}

