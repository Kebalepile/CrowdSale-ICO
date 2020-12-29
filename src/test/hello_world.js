const helloWorld = artifacts.require("helloWorld");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("helloWorld", function (/* accounts */) {
  it("should assert true", async function () {
    await helloWorld.deployed();
    return assert.isTrue(true);
  });
});
