import { Unit, Timer } from "w3ts";
import { Players } from "w3ts/globals";
import { AngleBetweenPoints } from '../libs/utils'


const BUILD_DATE = compiletime(() => new Date().toUTCString());
const TS_VERSION = compiletime(() => require("typescript").version);
const TSTL_VERSION = compiletime(() => require("typescript-to-lua").version);

export function init() {
  print(`Build: ${BUILD_DATE}`);
  print(`Typescript: v${TS_VERSION}`);
  print(`Transpiler: v${TSTL_VERSION}`);
  print(" ");
  print("============================");

  const ang = AngleBetweenPoints(0, 0, 200, 200)
  print(ang)

  const unit = new Unit(Players[0], FourCC("hfoo"), -1500, -1500, 270);
  unit.name = "TypeScript";

  new Timer().start(1.00, true, () => {
    unit.color = Players[math.random(0, bj_MAX_PLAYERS)].color
  });
}
