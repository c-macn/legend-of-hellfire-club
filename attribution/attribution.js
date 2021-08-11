(() => {
  const columns = document.getElementById('attribution-columns');

  const licenses = {
    "CC-0": {
      name: "CC-0",
      link: "https://creativecommons.org/publicdomain/zero/1.0/"
    },
    "CC-BY-3": {
      name: "CC BY 3.0",
      link: "https://creativecommons.org/licenses/by/3.0/"
    },
    "CC-BY-NC-3": {
      name: "CC BY-NC 3.0",
      link: "https://creativecommons.org/licenses/by-nc/3.0/"
    }
  };

  const attributions = [
    {
      title: 'Sipping Drink',
      source: 'https://freesound.org/people/Sheyvan/sounds/471078/',
      licence: licenses['CC-0'],
      author: { name: 'Sheyvan', profile: 'https://freesound.org/people/Sheyvan/' }
    },
    {
      title: 'JK Bottle Break',
      source: 'https://freesound.org/people/cmusounddesign/sounds/85107/',
      licence: licenses['CC-BY-3'],
      author: { name: 'cmusounddesign', profile: 'https://freesound.org/people/cmusounddesign/' }
    },
    {
      title: 'Indoor Footsteps',
      source: 'https://freesound.org/people/dkiller2204/sounds/366111/',
      licence: licenses['CC-0'],
      author: { name: 'dkiller2204', profile: 'https://freesound.org/people/dkiller2204/' }
    },
    {
      title: 'Magic Spell',
      source: 'https://freesound.org/people/qubodup/sounds/442774/',
      licence: licenses['CC-0'],
      author: { name: 'qubodup', profile: 'https://freesound.org/people/qubodup/' }
    },
    {
      title: 'Magic',
      source: 'https://freesound.org/people/RICHERlandTV/sounds/216089/',
      licence: licenses['CC-BY-3'],
      author: { name: 'RICHERlandTV', profile: 'https://freesound.org/people/RICHERlandTV/' }
    },
    {
      title: 'Doom Bell',
      source: 'https://freesound.org/people/Ev-Dawg/sounds/335991/',
      licence: licenses['CC-BY-NC-3'],
      author: { name: 'Ev-Dawg', profile: 'https://freesound.org/people/Ev-Dawg/' }
    },
    {
      title: '03 Cardboard Box Opening',
      source: 'https://freesound.org/people/Coral_Island_Studios/sounds/459422/',
      licence: licenses['CC-0'],
      author: { name: 'Coral_Island_Studios', profile: 'https://freesound.org/people/Coral_Island_Studios' }
    },
    {
      title: 'laugh',
      source: 'https://freesound.org/people/klankbeeld/sounds/126113/',
      licence: licenses['CC-BY-3'],
      author: { name: 'klankbeeld', profile: 'https://freesound.org/people/klankbeeld/' }
    },
    {
      title: 'rat-squeak',
      source: 'https://freesound.org/people/toefur/sounds/288941/',
      licence: licenses['CC-0'],
      author: { name: 'toefur', profile: 'https://freesound.org/people/toefur' }
    },
    {
      title: 'Glass Bottle Rolling on Wood',
      source: 'https://freesound.org/people/krnash/sounds/389797/',
      licence: licenses['CC-0'],
      author: { name: 'krnash', profile: 'https://freesound.org/people/krnash/' }
    },
    {
      title: 'Blood and gore FX performance 2',
      source: 'https://freesound.org/people/Slave2theLight/sounds/157113/',
      licence: licenses['CC-BY-3'],
      author: { name: 'Slave2theLight', profile: 'https://freesound.org/people/Slave2theLight' }
    },
    {
      title: 'Fire burning in stove',
      source: 'https://freesound.org/people/Jagadamba/sounds/256419/',
      licence: licenses['CC-BY-NC-3'],
      author: { name: 'Jagadamba', profile: 'https://freesound.org/people/Jagadamba/' }
    },
    {
      title: 'I Will Find You',
      source: 'https://darrencurtis.bandcamp.com/track/i-will-find-you',
      licence: licenses['CC-BY-3'],
      author: { name: 'Darren Curtis', profile: 'https://darrencurtis.bandcamp.com/' }
    },
    {
      title: 'I\'m Not What I Thought',
      source: 'https://darrencurtis.bandcamp.com/track/im-not-what-i-thought',
      licence: licenses['CC-BY-3'],
      author: { name: 'Darren Curtis', profile: 'https://darrencurtis.bandcamp.com/' }
    },
    {
      title: 'monster speak',
      source: 'https://freesound.org/people/ibm5155/sounds/174922/',
      licence: licenses['CC-BY-3'],
      author: { name: 'ibm5155', profile: 'https://freesound.org/people/ibm5155/' }
    }
  ];

  const createNode = (attribution) => {
    return `
     <div class="column py-2 px-5 is-full">
       <div class="card">
         <div class="card-content">
          <dl>
            <dt>Title: </dt>
            <dd>${attribution.title}</dd>

            <dt>Author: </dt>
            <dd><a href="${attribution.author.profile}">${attribution.author.name}</a></dd>

            <dt>Source: </dt>
            <dd><a href="${attribution.source}">${attribution.source}</a></dd>

            <dt>Licence: </dt>
            <dd><a href="${attribution.licence.licence}">${attribution.licence.name}</a></dd>
          </dl>
         </div>
       </div>
     </div>
     <br/>
    `;
  };

  columns.insertAdjacentHTML('afterBegin', attributions.map(createNode).join(''));
})();