const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("TrybeModule", (m) => {
  const trybe = m.contract("Trybe", [5]);

  return { trybe };
});