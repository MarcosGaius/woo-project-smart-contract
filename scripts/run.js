const main = async() => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal"); //hre é um objeto com todas funcionalidades do HRE
    const waveContract = await waveContractFactory.deploy({value: hre.ethers.utils.parseEther("0.1"),});
    await waveContract.deployed();
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address); //provider é uma abstração para ler a blockchain

    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

    let wooCount; 
    wooCount = await waveContract.getTotalWoo();
    console.log(wooCount.toNumber());

    let wooTxn = await waveContract.woo("EAE RAPAZIADA!");
    await wooTxn.wait();
    
    // wooTxn = await waveContract.woo("EAE RAPAZIADA! 2");
    // await wooTxn.wait();

    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

    // wooTxn = await waveContract.connect(randomPerson).woo("MENSAGEM DIFERETNE!");
    // await wooTxn.wait();

    // let allWoo = await waveContract.getAllWoo();
    // console.log(allWoo); //não precisa do wait pois é view
    
    wooTxn = await waveContract.connect(randomPerson).wooBack(1);
    await wooTxn.wait()
    
    wooTxn = await waveContract.connect(randomPerson).wooBack(1);
    await wooTxn.wait()

    let wooBack = await waveContract.getAllWooBack(1);
    console.log(wooBack);
};

const runMain = async() => {
    try{
        await main();
        process.exit(0);
    }
    catch(error){
        console.log(error);
        process.exit(1);
    }
};

runMain();