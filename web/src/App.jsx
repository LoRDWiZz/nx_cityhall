import { useState, useEffect } from 'react'
import { Center, Paper, Title, Text, Stack, Grid, Tabs, Space, CloseButton, Group, Button, Transition } from '@mantine/core';
import { IconBriefcaseFilled, IconIdFilled } from '@tabler/icons-react';
const isEnvBrowser = () => !window.invokeNative;
import classes from './App.module.css';

const debugJobs = [
  { id: 'unemployed', label: 'Unemployed' },
  { id: 'taxi', label: 'Taxi' },
  { id: 'garbage', label: 'Garbagner' },
]

const debugLicenses = [
  {
    id: 'id_card',
    item: 'id_card',
    label: 'ID Card',
    price: 50,
  },
  {
    id: 'driver_license',
    item: 'driver_license',
    label: 'Driver License',
    price: 150,
  },
]

function App() {
  const [visible, setVisible] = useState(isEnvBrowser())
  const [jobs, setJobs] = useState(isEnvBrowser() ? debugJobs : [])
  const [licenses, setLicenses] = useState(isEnvBrowser() ? debugLicenses : [])

  const closeMenu = () => {
    setVisible(false)
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(null),
    })
  }

  const selectJob = (job) => {
    fetch(`https://${GetParentResourceName()}/selectJob`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(job),
    })
  }

  const selectLicense = (license) => {
    fetch(`https://${GetParentResourceName()}/selectLicense`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(license),
    })
  }

  useEffect(() => {
    const handler = (event) => {
      const data = event.data
      if (data.type === 'showMenu') {
        setVisible(data.visible)
        setJobs(data.jobs)
        setLicenses(data.licenses)
      }
    }
    window.addEventListener('message', handler)
    return () => window.removeEventListener('message', handler)
  }, [])

  return (
    <>
      <Transition mounted={visible} transition="slide-up" duration={150}>
        {(styles) =>
          <div style={styles}>
            <Center h={"100vh"}>
              <Paper p="lg" radius="sm" w={800} bg={"rgba(3, 11, 18, 0.9)"}>
                <div style={{ position: "relative", textAlign: "center" }}>
                  <Title order={2} c={"#2596be"}>Los Santos Cityhall</Title>

                  <CloseButton size={'lg'} c={"#2596be"} style={{ position: "absolute", right: 0, top: 0 }} className={classes.close} onClick={closeMenu} />
                </div>

                <Space h="md" />
                <Tabs defaultValue="jobs" radius={0}>
                  <Tabs.List grow>
                    <Tabs.Tab value="jobs" color="#2596be" fw={'bold'} leftSection={<IconBriefcaseFilled />} className={classes.tab}>
                      Jobs
                    </Tabs.Tab>
                    <Tabs.Tab value="licenses" color="#2596be" fw={'bold'} leftSection={<IconIdFilled />} className={classes.tab}>
                      Licenses
                    </Tabs.Tab>
                  </Tabs.List>
                  <Space h="md" />
                  <Tabs.Panel value="jobs">
                    <Grid>
                      {jobs.map((job) => (
                        <Grid.Col span={6} key={job.id}>
                          <Paper p="md" radius="sm" bg={"rgba(3, 11, 18, 0.9)"}>
                            <Group justify='space-between' align='center'>
                              <Text>{job.label}</Text>
                              <Button variant="light" color="#2596be" radius={'sm'} onClick={()=>selectJob(job)} leftSection={<IconBriefcaseFilled />}>Take a job</Button>
                            </Group>
                          </Paper>
                        </Grid.Col>
                      ))}
                    </Grid>
                  </Tabs.Panel>

                  <Tabs.Panel value="licenses">
                    <Grid>
                      {licenses.map((license) => (
                        <Grid.Col span={6} key={license.id}>
                          <Paper p="md" radius="sm" bg={"rgba(3, 11, 18, 0.9)"}>
                            <Group justify='space-between' align='center'>
                              <Stack gap={1}>
                                <Text fw={'bold'}>{license.label}</Text>
                                <Text c={'dimmed'}>Price: {license.price}$</Text>
                              </Stack>
                              <Button variant="light" color="#2596be" radius={'sm'} onClick={()=>selectLicense(license)} leftSection={<IconIdFilled />}>Take a document</Button>
                            </Group>
                          </Paper>
                        </Grid.Col>
                      ))}
                    </Grid>
                  </Tabs.Panel>
                </Tabs>
              </Paper>
            </Center>
          </div>
        }
      </Transition>
    </>
  )
}

export default App
