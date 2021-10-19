pragma solidity >=0.6.12 <0.9.0;

import {ILendingPool} from "@aave/protocol-v2/contracts/interfaces/ILendingPool.sol";
import { IERC20 } from "./interface/IERC20.sol";

//add onlyonwer
contract AaveLiquidate{
    ILendingPool AaveLendingPool;
    address UniswapRouter;


    constructor(address _lendingpool, address _router) {
        AaveLendingPool = ILendingPool(_lendingpool);
        UniswapRouter = _router;
    }

    struct LiquidationParams{
        address collateralAsset;
        address debtAsset;
        address user;
        uint256 exactdebtToCover;
        bool receiveAToken;
    }

    struct FlashLoanParams{
        address[] assets;
        uint256[] amounts;
        uint256[] modes;
        uint128 i;
    }

    struct Asset{
        address asset;
        uint256 amount;
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool){

        Asset[] memory borrows;
        Asset[] memory buys;


        for(uint128 i = 0; i < assets.length; i++){
            for(uint128 j = 0; j < borrows.length; j++){
                if(borrows[j].asset == assets[i]){
                    borrows[j].amount += amounts[i];
                    continue;
                }
            }
            borrows.push(new BorrowAsset(assets[i], amounts[i]));
        }

        //빌린상태
        (address[] memory collateralAssets, address[] memory users) = abi.decode(params, (address[], address[]));
        for(uint128 i = 0; i < assets.length; i++){
            IERC20(assets[i]).approve(address(AaveLendingPool), amounts[i]);
            AaveLeningPool.LiquidationCall(collateralAssets[i], assets[i], users[i], amounts[i], false);

            
            // swap collateralasset to asset(debtasset) + premiums
            // approve
        }

        for(uint128 i = 0; i < borrows.length; i++){
            
        }

    }

    function Liquidateinternal() internal{

    }

// 청산 대상 유저 주소넘기면
// 유저 정보 조회하고 담보-금액 array생성
// 가장 큰 빛 청산
//  빌리고 콜백 청산 스왑 상환
// 아직 더 갚을 수 있으면 한번 더 청산(보통은 한번 더 못할꺼다..)

    function LiquidatePositionsWithFlashloan(LiquidationParams[] memory params) external {
        FlashLoanParams memory vars;

        for(vars.i = 0; vars.i < params.length; vars.i++){
            vars.assets[i] = params[i].debtAsset;
            vars.amounts[i] = params[i].exactdebtToCover;
            vars.modes[i] = 0;
        }
        //debt asset 빌리고 executeoper 실행시키고 스왑하고 갚는다.

        AaveLendingPool.flashLoan(
            address(this),
            vars.assets,
            vars.amounts,
            vars.modes,
            address(0),
            "",
            0x34
        );

        //emit event
    }

    function swap() internal returns(){

    }

    function collect() external{

    }
    
}