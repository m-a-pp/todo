enum Importance{
  basic,
  low,
  important
}

List<ToDo> toDoList = [];

class ToDo{
  String id;
  String text;
  Importance? importance;
  DateTime? deadline;
  bool done;
  DateTime? created;
  DateTime? updated;
  ToDo({required this.id, required this.text,required this.importance, this.deadline,required this.done,required this.created,required this.updated});


}

ToDo toDoI(int i){
  return toDoList[i];
}

int toDoLength(){
   return toDoList.length;
}

void deleteToDo(ToDo toDo){
  toDoList.remove(toDo);
}

void addToDo(ToDo newToDo){
  toDoList.add(newToDo);
}

ToDo? findToDo(String id){
  for(var toDo in toDoList){
    if(toDo.id == id) return toDo;
  }
  return null;
}