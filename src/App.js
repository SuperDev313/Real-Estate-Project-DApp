import { useEffect, useState } from 'react';
import { ethers } from 'ethers';

// Components
import Navigation from './components/Navigation';
import Home from './components/Home';

// ABIs
import RealEstateABI from './abis/RealEstate.json'
import EscrowABI from './abis/Escrow.json'

// Config
let realEstateAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"
let escrowAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512"
let ethSigner

function App() {
  const [provider, setProvider] = useState(null)
  const [escrow, setEscrow] = useState(null)

  const [account, setAccount] = useState(null)

  const [homes, setHomes] = useState([])
  const [home, setHome] = useState({})
  const [toggle, setToggle] = useState(false);

  //here the Blockchain links with the ReactApp
  const loadBlockchainData = async () => {

    const provider = new ethers.providers.Web3Provider(window.ethereum)
    setProvider(provider)
    const network = provider.getNetwork()
    ethSigner = provider.getSigner()

    //conecting RealEstate Contract.
    const RealEstateInstance = new ethers.Contract(realEstateAddress, RealEstateABI, provider)
    const totalSupply = await RealEstateInstance.totalSupply();
    const homes = [] //storage of housing/nfts

    const escrowInstance = new ethers.Contract(escrowAddress, EscrowABI, provider)
    setEscrow(escrowInstance)

    for (var i = 1; i <= totalSupply; i++) {
      const uri = await RealEstateInstance.tokenURI(i);
      const response = await fetch(uri, {
        method: "GET",
        headers: {
          Accept: "application/json"
        },
      }).then((res) => res.json())

      homes.push(response)
    }

    setHomes(homes)

    //Interaction with Connect Metamask button
    // Account Change function
    window.ethereum.on('accountsChanged', async () => {
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      const account = ethers.utils.getAddress(accounts[0])
      setAccount(account);
    })

  }

  useEffect(() => {
    loadBlockchainData()
  }, [])

  const togglePop = (home) => {
    setHome(home)
    toggle ? setToggle(false) : setToggle(true);
  }

  return (
    <div>
      <Navigation account={account} setAccount={setAccount} />


      <div className='cards__section'>

        <h3>Get to live & hang where the F•R•I•E•N•D•S did</h3>

        <hr />

        <div className='cards'>
          {homes.map((home, index) => (
            <div className='card' key={index} onClick={() => togglePop(home)}>
              <div className='card__image'>
                <img src={home.image} alt="Home" />
              </div>
              <div className='card__info'>
                <h4>{home.attributes[0].value} ETH</h4>
                <p>
                  <strong>{home.attributes[2].value}</strong> bds |
                  <strong>{home.attributes[3].value}</strong> ba |
                  <strong>{home.attributes[4].value}</strong> sqft
                </p>
                <p>{home.address}</p>
              </div>
            </div>
          ))}
        </div>

      </div>

      {toggle && (
        <Home home={home} provider={provider} account={account} escrow={escrow} togglePop={togglePop} />
      )}

    </div>
  );
}

export default App;
