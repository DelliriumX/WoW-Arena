// public region PATHING_MAP
// ================================
//		CONFIGURE THE SYSTEM
// ================================
const MAX_MISSILES = 100									//	Maximum amount of missiles at a time
const MIN_ANGLE_CORRECTION = 1.0					//	Minimum angle of missile arcing
const MAX_ANGLE_CORRECTION = 20.0					//	Maximum angle of missile arcing
const TIMER_TICK_INTERVAL = 0.0312500			// (32 ticks per second)
const UNIT_TARGET_HEIGHT = 80.0						//	Assumed unit-target height
const UNIT_COLLISION_WIDTH = 48.0					//	Assumed unit-target width (for collision)
const USE_PATHING_COLLISION = true				//	If true, any unwalkable pathing will have a fixed pathing height (cliffs will not work well)
const PATHING_HEIGHT = 96.0               //	Assumed height of any pathing-blocker (cliffs included)
// ================================
//		onStop method flags
// ================================
const t: timer = CreateTimer()            //	Global missiles timer
const missiles: Number[] = []             //	Active missiles storage array
let N: number = 0                         //	Active missile count / New Missile Index for array
let timerRunning: boolean = false         //	Timer active flag