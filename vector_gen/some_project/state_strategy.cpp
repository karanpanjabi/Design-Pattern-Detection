#include <iostream>
#include <string>

namespace State_Pattern
{
/*
 * MusicPlayer.h
 *
 *  Created on: May 7, 2017
 *      Author: rlarson
 */

#ifndef MUSICPLAYER_H_
#define MUSICPLAYER_H_

class MusicPlayerState;

class MusicPlayer {
public:
	enum State
	{
		ST_STOPPED,
		ST_PLAYING,
		ST_PAUSED
	};

	MusicPlayer();
	virtual ~MusicPlayer();

	void Play();
	void Pause();
	void Stop();

	void SetState(State state);

private:
	MusicPlayerState * m_pState;
};

#endif /* MUSICPLAYER_H_ */

/*
 * MusicPlayerState.h
 *
 *  Created on: May 7, 2017
 *      Author: rlarson
 */

#ifndef MUSICPLAYERSTATE_H_
#define MUSICPLAYERSTATE_H_


class MusicPlayer;

class MusicPlayerState {
public:
	MusicPlayerState(std::string name);
	virtual ~MusicPlayerState();

	virtual void Play(MusicPlayer * player);
	virtual void Pause(MusicPlayer * player);
	virtual void Stop(MusicPlayer * player);

	std::string GetName() { return m_name; }

private:
	std::string   m_name;
};

#endif /* MUSICPLAYERSTATE_H_ */

/*
 * PausedState.h
 *
 *  Created on: May 7, 2017
 *      Author: rlarson
 */

#ifndef PAUSEDSTATE_H_
#define PAUSEDSTATE_H_


class MusicPlayer;

class PausedState : public MusicPlayerState {
public:
	PausedState();
	virtual ~PausedState();

	virtual void Play(MusicPlayer * player);
	virtual void Stop(MusicPlayer * player);
};

#endif /* PAUSEDSTATE_H_ */

/*
 * PlayingState.h
 *
 *  Created on: May 7, 2017
 *      Author: rlarson
 */

#ifndef PLAYINGSTATE_H_
#define PLAYINGSTATE_H_


class MusicPlayer;

class PlayingState : public MusicPlayerState {
public:
	PlayingState();
	virtual ~PlayingState();

	virtual void Pause(MusicPlayer * player);
	virtual void Stop(MusicPlayer * player);
};

#endif /* PLAYINGSTATE_H_ */

/*
 * StoppedState.h
 *
 *  Created on: May 7, 2017
 *      Author: rlarson
 */

#ifndef STOPPEDSTATE_H_
#define STOPPEDSTATE_H_


class MusicPlayer;

class StoppedState : public MusicPlayerState {
public:
	StoppedState();
	virtual ~StoppedState();

	virtual void Play(MusicPlayer * player);
};

#endif /* STOPPEDSTATE_H_ */

/*
 * MusicPlayerState.cpp
 *
 *  Created on: May 7, 2017
 *      Author: rlarson
 */



MusicPlayerState::MusicPlayerState(std::string name)
: m_name(name)
{

}

MusicPlayerState::~MusicPlayerState() {
}

void MusicPlayerState::Play(MusicPlayer * player)
{
	std::cout << "Illegal state transition from " << GetName() << " to Playing\n";
}

void MusicPlayerState::Pause(MusicPlayer * player)
{
	std::cout << "Illegal state transition from " << GetName() << " to Paused\n";
}

void MusicPlayerState::Stop(MusicPlayer * player)
{
	std::cout << "Illegal state transition from " << GetName() << " to Stopped\n";
}


/*
 * PausedState.cpp
 *
 *  Created on: May 7, 2017
 *      Author: rlarson
 */


PausedState::PausedState()
: MusicPlayerState(std::string("Paused")) {
}

PausedState::~PausedState() {
}

void PausedState::Play(MusicPlayer * player)
{
	player->SetState(MusicPlayer::ST_PLAYING);
}

void PausedState::Stop(MusicPlayer * player)
{
	player->SetState(MusicPlayer::ST_STOPPED);
}


/*
 * PlayingState.cpp
 *
 *  Created on: May 7, 2017
 *      Author: rlarson
 */

PlayingState::PlayingState()
: MusicPlayerState(std::string("Playing")) {
}

PlayingState::~PlayingState() {
}

void PlayingState::Pause(MusicPlayer * player)
{
	player->SetState(MusicPlayer::ST_PAUSED);
}

void PlayingState::Stop(MusicPlayer * player)
{
	player->SetState(MusicPlayer::ST_STOPPED);
}


/*
 * StoppedState.cpp
 *
 *  Created on: May 7, 2017
 *      Author: rlarson
 */

StoppedState::StoppedState()
: MusicPlayerState(std::string("Stopped")) {
}

StoppedState::~StoppedState() {
}

void StoppedState::Play(MusicPlayer * player)
{
	player->SetState(MusicPlayer::ST_PLAYING);
}


/*
 * MusicPlayer.cpp
 *
 *  Created on: May 7, 2017
 *      Author: rlarson
 */



MusicPlayer::MusicPlayer()
: m_pState(new StoppedState()){

}

MusicPlayer::~MusicPlayer() {
	delete m_pState;
}

void MusicPlayer::Play() {
	m_pState->Play(this);
}

void MusicPlayer::Pause() {
	m_pState->Pause(this);
}

void MusicPlayer::Stop() {
	m_pState->Stop(this);
}

void MusicPlayer::SetState(State state)
{
	std::cout << "changing from " << m_pState->GetName() << " to ";
	delete m_pState;

	if(state == ST_STOPPED)
	{
		m_pState = new StoppedState();
	}
	else if(state == ST_PLAYING)
	{
		m_pState = new PlayingState();
	}
	else
	{
		m_pState = new PausedState();
	}

	std::cout << m_pState->GetName() << " state\n";
}

}

namespace Strategy_Pattern
{
#ifndef FLYBEHAVIOR_HEADER_FILE
#define FLYBEHAVIOR_HEADER_FILE

class FlyBehavior{
  public:
    virtual void fly() = 0;

    virtual ~FlyBehavior(){
    }    
};

class NormalFly:public FlyBehavior
{
  public:
    void fly(){
      std::cout << "I am a normal flying duck" << std::endl;
    } 
};


class NoFly:public FlyBehavior
{
  public:
    void fly(){
      std::cout << "I am not a flying duck. I don't fly" << std::endl;
    } 
};

class JetpackFly:public FlyBehavior
{
  public:
    void fly(){
      std::cout << "I am a duck with JetPack. I can fly fast" << std::endl;
    } 
};

#endif

#ifndef QUACKBEHAVIOR_HEADER_FILE
#define QUACKBEHAVIOR_HEADER_FILE

class QuackBehavior{
  public:
    virtual void quack() = 0;
    virtual ~QuackBehavior(){}
};

class NormalQuack:public QuackBehavior
{
  public:
    void quack(){
      std::cout << "Quack" << std::endl;
    } 
};


class Squeak:public QuackBehavior
{
  public:
    void quack(){
      std::cout << "Squeak" << std::endl;
    } 
};

class NoSound:public QuackBehavior
{
  public:
    void quack(){
      std::cout << "NoSound" << std::endl;
    } 
};

#endif

class Duck
{
  public:
    Duck(std::string dcBreed, FlyBehavior* fb, QuackBehavior* qb):flyB(fb), quackB(qb), duckBreed(dcBreed)
    {
    }
   
    //Write getter and setter methods here.  
    std::string getDuckBreed()
    {
       return duckBreed;
    }

    void setFlyBehavior(FlyBehavior *newFlyB){
       delete flyB;
       flyB = newFlyB;
    }
 
    void setQuackBehavior(QuackBehavior *newQuackB){
       delete quackB;
       quackB = newQuackB;
    }

    void makeDuckFly(){
       flyB->fly();
    }

    void makeDuckQuack(){
       quackB->quack();
    }

    ~Duck(){
       delete flyB;
       delete quackB;
    }

  private:
    std::string duckBreed;
    FlyBehavior *flyB;
    QuackBehavior *quackB;
};

class MallardDuck:public Duck
{
  public:
    MallardDuck():Duck("MallardDuck", new NormalFly(), new NormalQuack()){
    }
};


class ToyDuck:public Duck
{
  public:
    ToyDuck():Duck("ToyDuck", new NoFly(), new Squeak()){
    }
};
}

int main()
{
    State_Pattern::MusicPlayer player;

	player.Play();
	player.Pause();
	player.Stop();


    Strategy_Pattern::MallardDuck *duck = new Strategy_Pattern::MallardDuck();

    std::cout << "Duck type:" << duck->getDuckBreed() << std::endl;
    duck->makeDuckFly();
    duck->makeDuckQuack();

    std::cout << "*** Changing fly behavior to JetPackFly" << std::endl;
    duck->setFlyBehavior(new Strategy_Pattern::JetpackFly());
    duck->makeDuckFly();
}