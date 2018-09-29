#include <iostream>
#include <queue>
#include <fstream>

using namespace std;

queue <string> stateList;
queue <string> allState;
queue <string> finishState;

ofstream myfile;

bool isValid(string board,int fillIn){
//Mengembalikan true jika fillIn adalah angka valid untuk board
  return board[fillIn-1] == '0';
}

void finishAll(){
//Menyelesaikan semua pekerjaan dan menulisnya ke file
  cout<<"Menulis file"<<endl;
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
//cek apakah kemenangan valid (hanya komputer yang boleh menang)
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
  //1  = cpu menang
  //2  = seri
  //0  = lanjut

  //baris
  for (int i=0; i<9; i+=3)
  {
    if(board[i]==board[i+1] && board[i+1]==board[i + 2] && board[i]!='0')
    {
      cout<<"Menang - baris "<<((i/3)+1)<<endl;
      return cekValidWin(board,i);
    }
  }

  //kolom
  for(int i=0; i<3; i++)
  {
    if (board[i]==board[i+3] && board[i+3]==board[i+6] && board[i]!='0')
    {
      cout<<"Menang - kolom "<<(i+1)<<endl;
      return cekValidWin(board,i);
    }
  }

  //diagonal atas kiri ke bawah kanan
  if(board[0]==board[4] && board[4]==board[8] && board[0]!='0')
  {
    cout<<"Menang - diagonal atas kiri -> bawah kanan"<<endl;
    return cekValidWin(board,0);
  }

  // diagonal atas kanan ke bawah kiri
  if(board[2]==board[4] && board[4]==board[6] && board [2]!='0')
  {
    cout<<"Menang - diagonal atas kanan -> bawah kiri"<<endl;
    return cekValidWin(board,2);
  }


  //cek seri
  int state = 2;
  for (int i = 0; i < 9; i++) {
    if(board[i]=='0'){
      state = 0;
    }
  }

  if(state ==2){
    cout<<"Seri"<<endl;
  }

  return state;

}

void printBoard(string board){
//menceta
  cout<<endl;
  for (int i = 0; i < 9; i++) {
    cout<<board[i]<<" ";
    if(i==2 || i==5 || i==8){
      cout<<endl;
    }
  }
}

int askInput(string board){
//meminta input sampai input valid
//Jika input = -99, selesaikan program
  int input = 5;

  while (!isValid(board,input)) {
    printBoard(board);
    cout<<"enter input : ";
    cin>>input;

    if(input == -99){
      finishAll();
    }else if (!isValid(board, input)) {
      cout<<"Invalid input"<<endl;
    }
  }

  return input;
}

void appendToFile(string board,int loc){
//append to file (main table)
  if(loc!=9){
    myfile<<board<<" | ";
  }else{
    myfile<<board;
  }
}

void processState(string board){
//Memproses state (1 baris)

  //Print state awal
  myfile<<board<<" | ";
  //Copy board supaya bisa dimodifikasi
  string boardCopy = board;

  //Coba 1-9
  for (int i = 1; i <=9 ; i++) {

    board = boardCopy;

    //skip untuk angka 5
    if(i!=5){
      //Cek apakah sudah menang
      if(board[9] =='-'){
        //Cek input valid jika belum menang
        if(isValid(board,i)){
          //saat valid isi
          board[i-1] = 'X';

          //Minta input PC dan isi
          if(isFinish(board)==0){
            int pcInput = askInput(board);
            board[pcInput-1] = 'O';
          }

          //Cek menang
          int condition = isFinish(board);

          if (condition == 2){
            //seri
            board[9] = 'd';
            finishState.push(board);
          }else if (condition == 1) {
            //menang
            board[9] = 'w';
            finishState.push(board);
          }else if (condition == 99) {
            //quit error
            finishAll();
          }

          //Tambah pembatas kecuali di terakhir
          appendToFile(board, i);

          stateList.push(board);
        }else{
          //Invalid move
          appendToFile(board, i);
        }
      }else{
        //board menang atau seri
        appendToFile(board, i);
      }
    }



  }
  myfile<<"\n";
}

int main(){
  myfile.open("out.txt");
  myfile<<"                   1    |     2      |  3         |  4         |     6      |     7      |      8     |     9\n";

  string startState;

  cout<<"Tulis startState"<<endl;
  cout<<"1 = 0000O0000-"<<endl;
  cout<<"2 = O000X0000-"<<endl;
  cin>> startState;

  if(startState=="1"){
    startState = "0000O0000-";
  }else if (startState=="2") {
    startState = "O000X0000-";
  }

  stateList.push(startState);

  while(!stateList.empty()){
    processState(stateList.front());
    allState.push(stateList.front());
    stateList.pop();
  }

  finishAll();
  return 0;
}
