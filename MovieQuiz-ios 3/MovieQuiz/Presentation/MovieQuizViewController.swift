import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        showNextQuestion()
        
    }
    
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    
    @IBAction private func yesButton(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButton(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
   
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
   
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
   
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor
        
        if isCorrect {
            correctAnswers += 1
        }
        
        currentQuestionIndex += 1
        
        if currentQuestionIndex < questions.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showNextQuestion()
            }
        } else {
            showQuizResults()
        }
    }
    
    private func showNextQuestion() {
        let question = questions[currentQuestionIndex]
        let viewModel = QuizStepViewModel(
            image: UIImage(named: question.image) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        show(quiz: viewModel)
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func showQuizResults() {
        let alert = UIAlertController(
            title: "Конец",
            message: "Правльных ответов: \(correctAnswers) из \(questions.count)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Сыграть ещё раз", style: .default, handler: { _ in
            self.resetQuiz()
        }))
        present(alert, animated: true, completion: nil)
    }

    
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        showNextQuestion()
    }
   
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
 
}
