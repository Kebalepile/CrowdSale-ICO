// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Ownable.sol";
import "./KCoin.sol";

contract CrowdFund is Ownable {
    constructor(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _weiTokenPrice,
        uint256 _etherInvestmentObject
    ) public {
        startTime = _startTime;
        endTime = _endTime;
        weiInvestmentObjective = _etherInvestmentObject;
        crowdSaleToken = new KCoin(0);
        owner = msg.sender;

        for (uint8 i = 0; i < PriceLevel.length; i++) {
            if (i == 0) {
                tokenPrice[PriceLevel[i]] = _weiTokenPrice;
            }

            tokenPrice[PriceLevel[i]] = _weiTokenPrice * (i + 1);
        }

        weiTokenPrice = tokenPrice["level1"];
    }

    string[4] private PriceLevel = ["level1", "level2", "level3", "level4"];
    string public tokenPriceLevel = PriceLevel[0];

    uint256 public startTime;
    uint256 public endTime;
    uint256 public weiTokenPrice; //price of token being sold
    uint256 public weiInvestmentObjective; //minmum capital raise target.

    mapping(address => uint256) public investmentAmount;
    mapping(string => uint256) private tokenPrice;
    uint256 public investmentReceived; //total Ether received from investors
    uint256 public investmentRefunded; //total Ether refunded to investors.

    bool public isFinalized; //inidacted if crowdfunding is finalized
    bool public isRefundingAllowed; //indicates wheather refunding is allowed.

    KCoin public crowdSaleToken;

    event LogInvestment(address indexed investor, uint256 value);
    event LogTokenAsignment(address investor, uint256 numTokens);

    function adjustPriceLevel() external onlyOwner {
        bool level1 = investmentReceived <= 3000000000000000000000 wei;

        bool level2 = investmentReceived > 3000000000000000000000 wei &&
            investmentReceived <= 10000000000000000000000 wei;

        bool level3 = investmentReceived > 10000000000000000000000 wei &&
            investmentReceived <= 1000000000000000000 wei;

        bool level4 = investmentReceived > 15000000000000000000 wei;

        if (level1) {
            tokenPriceLevel = PriceLevel[0];
            weiTokenPrice = tokenPrice[tokenPriceLevel];
        } else if (level2) {
            tokenPriceLevel = PriceLevel[1];
            weiTokenPrice = tokenPrice[tokenPriceLevel];
        } else if (level3) {
            tokenPriceLevel = PriceLevel[2];
            weiTokenPrice = tokenPrice[tokenPriceLevel];
        } else if (level4) {
            tokenPriceLevel = PriceLevel[3];
            weiTokenPrice = tokenPrice[tokenPriceLevel];
        }
    }

    function invest() public payable {
        require(isValidInvestmentValue(msg.value));

        address investor = msg.sender;
        uint256 investment = msg.value;

        investmentAmount[investor] += investment;
        investmentReceived += investment;

        assignTokens(investor, investment);
        emit LogInvestment(investor, investment);
    }

    function isValidInvestmentValue(uint256 investment)
        internal
        view
        returns (bool)
    {
        bool nonZeroInvestment = investment != 0;
        bool withinCrowdsalePeriod = true; //block.timestamp >= startTime &&
        // block.timestamp <= endTime;
        bool correctAmount = investment >= tokenPrice[tokenPriceLevel];
        return nonZeroInvestment && withinCrowdsalePeriod && correctAmount;
    }

    function assignTokens(address beneficiary, uint256 amount) internal {
        uint256 numOfToken = calculateNumberOfToken(amount);
        crowdSaleToken.mint(beneficiary, numOfToken);
    }

    function calculateNumberOfToken(uint256 amount)
        internal
        view
        returns (uint256)
    {
        return amount / weiTokenPrice;
    }

    function finalize() public onlyOwner {
        if (isFinalized) revert();
        bool isCrowdsaleComplete = true; //block.timestamp > endTime;
        bool investmentObjectiveMet = investmentReceived >=
            weiInvestmentObjective;

        if (isCrowdsaleComplete) {
            if (investmentObjectiveMet) {
                crowdSaleToken.release();
            } else {
                isRefundingAllowed = true;
            }
            isFinalized = true;
        }
    }

    event Refund(address investor, uint256 value);

    function refund() public {
        if (!isRefundingAllowed) {
            revert();
        }
        // address investor = msg.sender;
        uint256 investment = investmentAmount[msg.sender];
        if (investment == 0) {
            revert();
        }
        investmentAmount[msg.sender] = 0;
        investmentRefunded += investment;
        emit Refund(msg.sender, investment);
        msg.sender.transfer(investment);
    }
}
