import Projectile from 'libs/projectiles'
import { AngleBetweenPoints, DistanceBetweenPoints } from 'libs/utils'
import SPELL_DATA from 'Spells/data'
import { EventQueue } from 'wc3ts-eventqueue/index'

class Frostbolt extends Projectile {
  constructor(target: unit, caster: unit, x: number, y: number, z: number, vectorX: number, vectorY: number, vectorZ: number) {
    super(123, 5)
    this.target = target
    this.caster = caster
    this.missile = AddSpecialEffect("Abilities\\Weapons\\LichMissile\\LichMissile.mdl", x, y)
    BlzSetSpecialEffectZ(this.missile, z)
    BlzSetSpecialEffectYaw(this.missile, bj_DEGTORAD * AngleBetweenPoints(0, 0, vectorX, vectorY))
    BlzSetSpecialEffectScale(this.missile, 1.2)
    BlzSetSpecialEffectPitch(this.missile, Atan2(vectorZ, DistanceBetweenPoints(0, 0, vectorX, vectorY)) * (-1))
    this.height = z
    this.missileRadius = 10.0
    this.area = 96.0

    this.acceleration = 400.0
    this.facingCorrection = 0.15
    this.speed = 600.0
    this.facingSpeed = 400.0
    this.maxDuration = 3.0
    this.unitCollision = true
  }

  onStop(flag) {
    if (flag == Projectile.TARGET_REACHED) {
      const data = SPELL_DATA.get(this.id)
      if (data) {
        print(data.damage)
      }
    }
    this.shouldDestroy = true
    return true
  }

  onInit(damage, duration) {
    SPELL_DATA.set(this.id, {
      damage: damage,
      duration: duration
    })
  }

  onDestroy() {
    const x = BlzGetLocalSpecialEffectX(this.missile)
    const y = BlzGetLocalSpecialEffectY(this.missile)
    let tempLocation = Location(x, y)
    let deathFx = AddSpecialEffectLocBJ(tempLocation, "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl")
    BlzSetSpecialEffectScale(deathFx, 0.8)
    BlzSetSpecialEffectZ(deathFx, GetLocationZ(tempLocation) + 50.0)

    EventQueue.AddLow(() => {
      // BlzPlaySpecialEffect(deathFx, ANIM_TYPE_DEATH)
      DestroyEffect(deathFx)
      RemoveLocation(tempLocation)
      deathFx = null
      tempLocation = null
    })
  }
}

export default Frostbolt