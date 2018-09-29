#include<iostream>
#include <queue>
#include <fstream>

using namespace std;

queue <string> stateList;
queue <string> allState;
queue <string> finishState;
bool pcTurn = true;

ofstream myfile;

bool isValid(string board,int fillIn){
  return board[fillIn-1] == '0';
}

void printDebug(string board){
  for (int i = 0; i < board.size(); i++) {
    cout<<i<<" "<<board[i]<<endl;
  }
}

void finishAll(){
  cout<<"trace dipanggil"<<endl;
  myfile.close();

  ofstream finishFile;
  finishFile.open("finish.txt");

  while(!finishState.empty()){
    finishFile<<finishState.front()<<"\n";
    finishState.pop();
  }

  finishFile.close();

  ofstream allFile;
  allFile.open("all.txt");

  while(!allState.empty()){
    allFile<<allState.front()<<"\n";
    allState.pop();
  }
  allFile.close();
  exit(0);
}

int cekValidWin(string board,int indeks){
  if(board[indeks]=='X'){
    cout<<"ERROR ABORT, PLAYER WIN"<<endl;
    cout<<"Board = "<<board<<endl;
    finishAll();
    return 99;
  }else{
    return 1;
  }
}



int isFinish(string board){
  //return
  //99 = error player WIN
  //1  = cpu win
  //2  = draw
  //0  = continue

  //row
  for (int i=0; i<9; i+=3)
  {
    if(board[i]==board[i+1] && board[i+1]==board[i + 2] && board[i]!='0')
    {
      cout<<"row is finish "<<i<<endl;
      return cekValidWin(board,i);
    }
  }

  //kolom
  for(int i=0; i<3; i++)
  {
    if (board[i]==board[i+3] && board[i+3]==board[i+6] && board[i]!='0')
    {
      cout<<"col is finish "<<i<<endl;
      return cekValidWin(board,i);
    }
  }

  //diagonal atas kiri ke bawah kanan
  if(board[0]==board[4] && board[4]==board[8] && board[0]!='0')
  {
    cout<<"diagonal atas kiri bawah kanan"<<endl;
    return cekValidWin(board,0);
  }

  // diagonal atas kanan ke bawah kiri
  if(board[2]==board[4] && board[4]==board[6] && board [2]!='0')
  {
    cout<<"diagonal atas kanan bawah kiri"<<endl;
    return cekValidWin(board,2);
  }


  //cek seri
  int state = 2;
  for (int i = 0; i < 9; i++) {
    if(board[i]=='0'){
      state = 0;
    }
  }

  return state;

}

void printBoard(string board){
  cout<<endl;
  for (int i = 0; i < 9; i++) {
    cout<<board[i]<<" ";
    if(i==2 || i==5 || i==8){
      cout<<endl;
    }
  }
}

int askInput(string board){
  int input = 5;
  while (!isValid(board,input)) {
    printBoard(board);
    cout<<"enter input : ";
    cin>>input;
    if(input == -99){
      finishAll();
    }
  }

  return input;
}

void processState(string board){
  myfile<<board<<" | ";
  string boardCopy = board;
  for (int i = 1; i <=9 ; i++) {
    board = boardCopy;
    if(board[9] =='-'){
      if(isValid(board,i)){
        board[i-1] = 'X';
        int pcInput = askInput(board);
        board[pcInput-1] = 'O';
        int condition = isFinish(board);
        if (condition == 2){
          board[9] = 'd';
          finishState.push(board);
        }else if (condition == 1) {
          board[9] = 'w';
          finishState.push(board);
        }else if (condition == 99) {
          finishAll();
        }
        if(i!=9){
          myfile<<board<<" | ";
        }else{
          myfile<<board;
        }

        stateList.push(board);
      }else{
        if(i!=5){
          myfile<<board<<" | ";
        }
      }
    }else{
      myfile<<board<<" | ";
    }

  }
  myfile<<"\n";
}

int main(){
  myfile.open("out.txt");
  myfile<<"                   1    |     2      |  3         |  4         |     6      |     7      |      8     |     9\n";

  string startState = "0000O0000-";

  stateList.push(startState);

  while(!stateList.empty()){
    //cout<<isFinish(stateList.front())<<endl;
    //printDebug(stateList.front());
    processState(stateList.front());
    allState.push(stateList.front());
    stateList.pop();
  }

  finishAll();
  return 0;
}
