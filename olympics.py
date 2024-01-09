import configparser
from operator import itemgetter

import sqlalchemy
from sqlalchemy import create_engine

# columns and their types, including fk relationships
from sqlalchemy import Column, Integer, Float, String, DateTime
from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship

# declarative base, session, and datetime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime

# configuring your database connection
config = configparser.ConfigParser()
config.read('config.ini')
u, pw, host, db = itemgetter('username', 'password', 'host', 'database')(config['db'])
dsn = f'postgresql://{u}:{pw}@{host}/{db}'
print(f'using dsn: {dsn}')

# SQLAlchemy engine, base class and session setup
engine = create_engine(dsn, echo=True)
Base = declarative_base()
Session = sessionmaker(engine)
session = Session()

# TODO: Write classes and code here

class AthleteEvent(Base):
    __tablename__ = 'athlete_event'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    age = Column(Integer)
    team = Column(String)
    noc = Column(String, ForeignKey('noc_region.noc'))
    sport = Column(String)
    event = Column(String)
    medal = Column(String)
    year = Column(Integer)
    season = Column(String)
    noc_region = relationship("NOCRegion", back_populates="athlete_events")

    def __str__(self):
        return f"{self.name}, {self.noc_region.region}, {self.event}, {self.year}, {self.season}, {self.medal}"
        
    def __repr__(self):
        return f"AthleteEvent(name={self.name}, noc_region={self.noc_region}, event={self.event}, year={self.year}, season={self.season}, medal={self.medal})"

   
class NOCRegion(Base):
    __tablename__ = 'noc_region'
    id = Column(Integer, primary_key=True)
    noc = Column(String)
    region = Column(String)
    athlete_events = relationship("AthleteEvent", back_populates="noc_region")

    def __str__(self):
        return f"{self.region}"

    def __repr__(self):
        return f"NOCRegion(region={self.region})"
    

# create tables if not exist
Base.metadata.create_all(engine)

# insert new record into athlete_event table
skateboarding = AthleteEvent(name='Yuto Horigome', age=21, team='Japan', medal='Gold', year=2020, season='Summer', noc='JPN', sport='Skateboarding', event='Skateboarding, Street, Men')
session.add(skateboarding)
session.commit()

# search for all rows in athlete_event with JPN as noc, year >= 2016, and medal == 'Gold'
result = session.query(AthleteEvent).join(NOCRegion).filter(AthleteEvent.noc == 'JPN', AthleteEvent.year >= 2016, AthleteEvent.medal == 'Gold')

# print out results
for row in result:
    print(row)

session.close()

