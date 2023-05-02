import 'dart:developer' as devtools show log;

const loginRoute = '/login/';
const registerRoute = '/register/';
const notesRoute = '/notes/';
const mainRoute = '/main/';
const verifyEmailRoute = '/verify-email/';
const createOrUpdateRoute = '/notes/new-notes/';

void writeLog(String log) {
  devtools.log(log);
}
