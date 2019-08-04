{-# LANGUAGE OverloadedStrings #-}

module Database.Bolt.Connection.Type where

import           Database.Bolt.Value.Type

import           Data.Default                    (Default (..))
import           Data.Map.Strict                 (Map)
import           Data.Text                       (Text)
import           Data.Word                       (Word16, Word32)
import           Network.Connection              (Connection)

-- |Configuration of driver connection
data BoltCfg = BoltCfg { magic         :: Word32  -- ^'6060B017' value
                       , version       :: Word32  -- ^'00000001' value
                       , userAgent     :: Text    -- ^Driver user agent
                       , maxChunkSize  :: Word16  -- ^Maximum chunk size of request
                       , socketTimeout :: Int     -- ^Driver socket timeout
                       , host          :: String  -- ^Neo4j server hostname
                       , port          :: Int     -- ^Neo4j server port
                       , user          :: Text    -- ^Neo4j user
                       , password      :: Text    -- ^Neo4j password
                       , secure        :: Bool    -- ^Use TLS or not
                       }

instance Default BoltCfg where
  def = BoltCfg { magic         = 1616949271
                , version       = 1
                , userAgent     = "hasbolt/1.3"
                , maxChunkSize  = 65535
                , socketTimeout = 5
                , host          = "127.0.0.1"
                , port          = 7687
                , user          = ""
                , password      = ""
                , secure        = False
                }

data Pipe = Pipe { connection :: Connection -- ^Driver connection socket
                 , mcs        :: Word16     -- ^Driver maximum chunk size of request
                 }

data AuthToken = AuthToken { scheme      :: Text
                           , principal   :: Text
                           , credentials :: Text
                           }
  deriving (Eq, Show)

data Response = ResponseSuccess { succMap   :: Map Text Value }
              | ResponseRecord  { recsList  :: [Value] }
              | ResponseIgnored { ignoreMap :: Map Text Value }
              | ResponseFailure { failMap   :: Map Text Value }
  deriving (Eq, Show)

data Request = RequestInit { agent :: Text
                           , token :: AuthToken
                           }
             | RequestRun  { statement  :: Text
                           , parameters :: Map Text Value
                           }
             | RequestAckFailure
             | RequestReset
             | RequestDiscardAll
             | RequestPullAll
  deriving (Eq, Show)
