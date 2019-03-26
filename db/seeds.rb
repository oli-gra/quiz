User.destroy_all
Question.destroy_all
Leaderboard.destroy_all

User.create(name:'Oli')
User.create(name:'Sam')

Question.create(
  question: 'Who is the only King without a tash in the standard 52 card deck?',
  category: 'General Knowledge',
  difficulty: 'medium',
  answer: 'Hearts',
  wrong_1: 'Diamonds',
  wrong_2: 'Spades',
  wrong_3: 'Clubs')

Question.create(
  question: 'A doctor with a PhD is a doctor of what?',
  category: 'General Knowledge',
  difficulty: 'medium',
  answer: 'Philosophy',
  wrong_1: 'Medicine',
  wrong_2: 'Phrenology',
  wrong_3: 'Science')
