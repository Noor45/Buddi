const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.deleteUser = functions.https.onCall(async (userUid, context) => {
  await admin.storage().bucket().deleteFiles({prefix: `${userUid}`});
  await admin.firestore().collection("users").doc(userUid).delete();
  await admin.auth().deleteUser(userUid);
  return "Account Deleted Successfully!";
});

exports.getGroupPost = functions.https.onCall(async (data, context) => {
  const uniName = data.uniName;
  //  const groups = data.groups;
  const limits = data.limits;
  const db = admin.firestore();
  const snapshot = await db.collection("post")
      .where("user_data.uni_name", "==", uniName)
      .orderBy("created_at", "desc").limit(limits).get();
  //  const snapshot = groups == null ?
  //    await db.collection("post").where("user_data.uni_name", "==", uniName)
  //        .orderBy("created_at", "desc").limit(limits).get() :
  //    await db.collection("post").where("user_data.uni_name", "==", uniName)
  //        .orderBy("created_at", "desc")
  //        .limit(limits).get();
  const posts = snapshot.docs.map((doc) => doc.data());
  //  if (groups != null) {
  //    const secondSnapshot = await db.collection("post")
  //        .where("group.id", "in", groups).limit(limits).get();
  //    const data = secondSnapshot.docs.map((doc) => doc.data());
  //    posts = [posts, data];
  //  }
  return posts;
});

exports.getInterestPosts = functions.https.onCall(async (data, context) => {
  const interests = data.interests;
  const limits = data.limit;
  const db = admin.firestore();
  const groupIds = [];
  const snapShot = await db.collection("groups")
      .where("category", "in", interests)
      .orderBy("created_at", "desc").limit(limits).get();
  const groups = snapShot.docs.map((doc) => doc.data());
  for (const group in groups) {
    if (groups.hasOwnProperty.call(groups, group)) {
      groupIds.push(groups[group]["id"]);
    }
  }
  const secondSnapShot = await db.collection("post")
      .where("group.id", "in", groupIds)
      .limit(limits).get();
  return secondSnapShot.docs.map((doc) => doc.data());
});

exports.deleteChat = functions.firestore.document("delete_message/{threadId}")
    .onCreate(async function(snapshot, context) {
      const snapData = snapshot.data();
      const threadId = snapData.threadId;
      const snap = await admin.firestore().collection("messages")
          .where("thread_id", "==", threadId).get();
      snap.docs.map(async (doc) => {
        const data = doc.data();
        console.log(data);
        await admin.firestore().collection("messages").doc(data.id).delete();
      });
      wait(2000); //    10 seconds in milliseconds
      await snapshot.ref.delete();
      console.log("after 7 seconds");
    });
/**
 * Function for wait.
 * @param {const} start.
 * @param {let} end.
 * @param {number} ms to get delay time.
 */
function wait(ms) {
  const start = new Date().getTime();
  let end = start;
  while (end < start + ms) {
    end = new Date().getTime();
  }
}


