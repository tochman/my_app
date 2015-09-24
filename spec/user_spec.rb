require 'user'
require 'bcrypt'

describe User do
  it { is_expected.to have_property :id }
  it { is_expected.to have_property :email }
  it { is_expected.to have_property :password_digest }

  it { is_expected.to validate_format_of(:email).with(:email_address) }
  it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }


  it { is_expected.to have_many :links }


  describe 'password encryption' do
    it 'encrypts password' do
      #binding.pry
      user = User.create(email: 'test@test.com', password: 'test', password_confirmation: 'test')
      expect(user.password_digest.class).to eq BCrypt::Password
      expect(user.password_digest.version).to eq '2a'
    end

    it 'raises error it password_confirmation does not match' do
      #binding.pry
      create_user = lambda { User.create(email: 'test@test.com', password: 'test', password_confirmation: 'wrong-test') }
      expect(create_user).to raise_error DataMapper::SaveFailureError
    end
  end

  describe 'user authentication' do
    before { @user = User.create(email: 'thomas@makersacademy.se', password: 'password', password_confirmation: 'password') }
    it 'succeeds with valid credentials' do
      expect(User.authenticate('thomas@makersacademy.se', 'password')).to eq @user
    end

    it 'fails with invalid credentials' do
      expect(User.authenticate('thomas@makersacademy.se', 'wrong-password')).to eq nil
    end
  end

  describe 'checks ownership' do

    subject { User.create(email: 'thomas@makersacademy.se', password: 'password', password_confirmation: 'password') }
    let(:object_1) { double(:object, user_id: subject.id) }
    let(:object_2) { double(:object, user_id: 100000) }

    it 'returns true if object user_id == subject.id' do
      expect(subject.is_owner?(object_1)).to eq true
    end

    it 'returns false if object user_id != subject.id' do
      expect(subject.is_owner?(object_2)).to eq false
    end
  end

end