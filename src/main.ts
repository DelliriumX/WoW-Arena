import { Timer } from "w3ts";
import { addScriptHook, W3TS_HOOK } from "w3ts/hooks";
import { init } from './Game/init'

addScriptHook(W3TS_HOOK.MAIN_AFTER, () => {
  new Timer().start(1, false, () => {
    xpcall(() => {
      init();
    }, (err) => {
      print(err)
    });
  })
});
