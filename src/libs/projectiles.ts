import { uid, AngleBetweenPoints, DistanceBetweenPoints } from './utils'

const projectiles: Projectile[] = []                //  Active projectiles storage array
let N: number = 0                                   //  Active projectile count / New Missile Index for array

abstract class Projectile {
  // ================================
  //    onStop method flags
  // ================================
  static TARGET_REACHED = "TARGET_REACHED"
  static PATHING_COLLISION = "PATHING_COLLISION"
  static UNIT_COLLISION = "UNIT_COLLISION"
  static MAX_DISTANCE_REACHED = "MAX_DISTANCE_REACHED"
  static MAX_DURATION_REACHED = "MAX_DURATION_REACHED"
  static TIMER_TICK_INTERVAL = 0.0312500            //  32 ticks per second   
  static USE_PATHING_COLLISION = true               //  If true, any unwalkable pathing will have a fixed pathing height (cliffs will not work well)
  static PATHING_HEIGHT = 96.0                      //  Assumed height of any pathing-blocker (cliffs included)
  static UNIT_TARGET_HEIGHT = 80.0                  //  Assumed unit-target height unless specified
  static UNIT_COLLISION_WIDTH = 48.0                //  Assumed unit-target width (for collision)
  static readonly PATHING_MAP = CreateRegion()

  static get count(): number { return N }
  static get collisionMap(): region { return Projectile.PATHING_MAP }
  
  static Ticker = () => {
    let i: number = 0;

    while (i < N) {
      projectiles[i].onTick()

      if (projectiles[i].shouldDestroy) {
        projectiles[i].destroy();
        projectiles[i] = projectiles[N - 1]
        N = N - 1
      } else {
        i = i + 1
      }
    }
  }

  private _id: number = uid.get()
  private _iteration: number = 0                    //	Iteration Counter

  protected missile: effect = null                  //	Missile effect
  protected missileVectorX: number = 0
  protected missileVectorY: number = 0
  protected missileVectorZ: number = 0
  protected height: number = 50.0

  protected target: unit = null                     //	Designated unit target for the spell
  protected caster: unit = null                     //	Caster, duh?
  protected targetX: number = 0.0
  protected targetY: number = 0.0
  protected targetZ: number = 0.0
  protected targetHeight: number = Projectile.UNIT_TARGET_HEIGHT

  protected acceleration: number = 0.0
  protected facingCorrection: number = 0.2
  protected facingSpeed: number = 1000.0
  protected speed: number = 1000.0
  protected distance: number = 0.0                  //	Total distance traveled
  protected duration: number = 0.0                  //	Total lifetime duration
  protected maxDistance: number = 0.0               //	Maximum distance traveled before stopping, if 0, ignore
  protected maxDuration: number = 0.0               //	Maximum lifetime before stopping, if 0, ignore

  protected area: number = 100.0                    //	Area for detecting unit collision (picking units)
  protected missileRadius: number = 15.0            //	Radius for detecting collision
  protected offset: number = 0.0                    //	Area offset in front of the missile, negative values for back
  protected collisionGroup: group = CreateGroup()   //	Units which were hit by the missile in the current iteration

  protected unitCollision: boolean = false          //	Determines if onUnitCollision is called when missile collides with a unit
  protected pathingCollision: boolean = true        //	Determines if onStop is called when missile collides with unpathable terrain
  protected shouldDestroy: boolean = false

  protected get iteration(): number { return this._iteration }
  protected get id(): number { return this._id }

  protected abstract onInit(...args: any[]): void
  protected abstract onDestroy(): void
  protected abstract onStop(flag: string): boolean
  protected onUnitCollision() { }

  protected onTick() {
    let missileX: number = BlzGetLocalSpecialEffectX(this.missile)
    let missileY: number = BlzGetLocalSpecialEffectY(this.missile)
    let missileZ: number = this.height
    let tempLocation: location
    let directionVectorX: number
    let directionVectorY: number
    let directionVectorZ: number
    let missileVectorIntensity: number
    let directionVectorIntensity: number
    let distance: number
    let step: number
    let vectorStepFactor: number
    let accelerationSpeed: number
    let facingCorrection: number = this.facingCorrection
    let stopTriggered: boolean = false
    // let pathingHeight: number
    let pathingCollision: boolean = false


    this._iteration = this._iteration + 1
    accelerationSpeed = this.acceleration * (Projectile.TIMER_TICK_INTERVAL * Projectile.TIMER_TICK_INTERVAL) * this._iteration
    if (this.maxDuration != 0.0)
      facingCorrection = this.facingCorrection + (this._iteration * Projectile.TIMER_TICK_INTERVAL) / this.maxDuration


    if (this.target != null) {
      this.targetX = GetUnitX(this.target)
      this.targetY = GetUnitY(this.target)
      tempLocation = Location(this.targetX, this.targetY)
      this.targetZ = GetLocationZ(tempLocation) + this.targetHeight
      RemoveLocation(tempLocation)
    }

    //	Direction Vector
    directionVectorX = this.targetX - missileX
    directionVectorY = this.targetY - missileY
    directionVectorZ = this.targetZ - missileZ
    directionVectorIntensity = SquareRoot((directionVectorX * directionVectorX) + (directionVectorY * directionVectorY) + (directionVectorZ * directionVectorZ))

    //	Set DirectionVector to step length
    step = (this.facingSpeed * Projectile.TIMER_TICK_INTERVAL + accelerationSpeed)
    vectorStepFactor = step / (directionVectorIntensity + 1.0)
    directionVectorX = directionVectorX * vectorStepFactor
    directionVectorY = directionVectorY * vectorStepFactor
    directionVectorZ = directionVectorZ * vectorStepFactor

    //	Missile vector (with DirectionVector influence correction - facingCorrection)
    this.missileVectorX = this.missileVectorX + directionVectorX * facingCorrection
    this.missileVectorY = this.missileVectorY + directionVectorY * facingCorrection
    this.missileVectorZ = this.missileVectorZ + directionVectorZ * facingCorrection
    missileVectorIntensity = SquareRoot((this.missileVectorX * this.missileVectorX) + (this.missileVectorY * this.missileVectorY) + (this.missileVectorZ * this.missileVectorZ))

    //	Set MissileVector to step length
    step = this.speed * Projectile.TIMER_TICK_INTERVAL + accelerationSpeed
    vectorStepFactor = step / missileVectorIntensity
    this.missileVectorX = this.missileVectorX * vectorStepFactor
    this.missileVectorY = this.missileVectorY * vectorStepFactor
    this.missileVectorZ = this.missileVectorZ * vectorStepFactor

    //	Snap MissileVector to target if target is closer then step length
    distance = directionVectorIntensity
    if (step + this.missileRadius > distance) {
      this.missileVectorX = this.targetX - missileX
      this.missileVectorY = this.targetY - missileY
      this.missileVectorZ = this.targetZ - missileZ
    }

    //	Move the projectile to proper coordinates / facing
    tempLocation = Location(missileX + this.missileVectorX, missileY + this.missileVectorY)
    this.height = Math.max(missileZ + this.missileVectorZ, GetLocationZ(tempLocation))
    BlzSetSpecialEffectPitch(this.missile, Atan2(this.missileVectorZ, DistanceBetweenPoints(0, 0, this.missileVectorX, this.missileVectorY)) * (-1))
    BlzSetSpecialEffectYaw(this.missile, bj_DEGTORAD * AngleBetweenPoints(0, 0, this.missileVectorX, this.missileVectorY))
    BlzSetSpecialEffectPosition(this.missile, missileX + this.missileVectorX, missileY + this.missileVectorY, this.height)

    //	Update reference fields
    this.distance = this.distance + step
    this.duration = this.duration + Projectile.TIMER_TICK_INTERVAL

    //	CHECK UNIT COLLISION
    if (this.unitCollision) {

      GroupClear(this.collisionGroup)
      GroupEnumUnitsInRange(this.collisionGroup, missileX + this.missileVectorX, missileY + this.missileVectorY, this.area / 2, null)
      if (FirstOfGroup(this.collisionGroup) != null) {
        this.onUnitCollision()
      }
    }

    //	CHECK STOP CONDITIONS		
    if (!stopTriggered && distance <= Projectile.UNIT_COLLISION_WIDTH + this.missileRadius) {
      stopTriggered = this.onStop(Projectile.TARGET_REACHED)
    }

    if (!stopTriggered && GetLocationZ(tempLocation) + this.missileRadius > this.height) {
      stopTriggered = this.onStop(Projectile.PATHING_COLLISION)
    }

    if (IsPointInRegion(Projectile.PATHING_MAP, missileX + this.missileVectorX, missileY + this.missileVectorY)) {
      pathingCollision = true
    } else if (Projectile.USE_PATHING_COLLISION) {
      pathingCollision = IsTerrainPathable(missileX + this.missileVectorX, missileY + this.missileVectorY, PATHING_TYPE_WALKABILITY) && (GetLocationZ(tempLocation) + Projectile.PATHING_HEIGHT + this.missileRadius > this.height)
    }

    if (!stopTriggered && (Projectile.USE_PATHING_COLLISION && pathingCollision)) {
      stopTriggered = this.onStop(Projectile.PATHING_COLLISION)
    }

    if (!stopTriggered && this.maxDistance != 0.0 && this.distance > this.maxDistance) {
      stopTriggered = this.onStop(Projectile.MAX_DISTANCE_REACHED)
    }

    if (!stopTriggered && this.maxDuration != 0.0 && this.duration > this.maxDuration) {
      stopTriggered = this.onStop(Projectile.MAX_DURATION_REACHED)
    }

    RemoveLocation(tempLocation)
    tempLocation = null
  }

  public Launch() {
    projectiles[N] = this
    N = N + 1
    // if (N > 0) TimerStart(t, Projectile.TIMER_TICK_INTERVAL, true, () => Projectile.Ticker())
  }

  public constructor(...args: any[]) {
    this.onInit(...args)
  }

  public destroy() {
    this.onDestroy()
    DestroyGroup(this.collisionGroup)
    DestroyEffect(this.missile)
    uid.release(this._id)
    this.collisionGroup = null
    this.target = null
    this.caster = null
    this.missile = null
  }
}

export default Projectile