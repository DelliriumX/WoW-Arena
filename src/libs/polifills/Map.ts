export default function Map() {
  const instance = {}
  let size = 0;

  const has = (key) => {
    return instance.hasOwnProperty(key)
  }

  const get = (key) => {
    if (instance.hasOwnProperty(key)) {
      return instance[key]
    }
    return null
  }

  const set = (key, value) => {
    if (!instance.hasOwnProperty(key)) {
      size = size + 1
    }
    instance[key] = value
  }

  const clear = (key?) => {
    if (!key) {
      for (const key in instance) {
        delete instance[key]
      }
      size = 0
    } else {
      if (instance.hasOwnProperty(key)) {
        delete instance[key]
        size = size - 1
      }
    }
  }

  const keys = () => {
    const result = [];
    for (const key in instance) {
      result[result.length] = key
    }
  }

  return {
    has: has,
    get: get,
    set: set,
    keys: keys,
    size: () => size,
    delete: (id) => clear(id),
    clear: () => clear(),
  }
}